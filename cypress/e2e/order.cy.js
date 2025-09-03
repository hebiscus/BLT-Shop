// cypress/e2e/order.cy.js
describe("Place order and send fax (local)", () => {
  const faxApi = Cypress.env("FAX_API_URL");
  const faxToken = Cypress.env("FAX_API_TOKEN");

  it("creates an order and posts a fax", () => {
    // 1) Start clean: read current faxes
    cy.request({
      url: `${faxApi}/faxes.json`,
      headers: { Authorization: `Bearer ${faxToken}` },
      failOnStatusCode: false
    }).then((res) => {
      expect([200, 403]).to.include(res.status); // 403 if token mismatch
      const initialCount = res.status === 200 ? res.body.length : 0;
      cy.wrap(initialCount).as("initialCount");
    });

    // 2) Go to the app and build an order (adapt selectors to your actual UI)
    cy.visit("/sandwiches", {
      auth: {
        username: Cypress.env("BASIC_AUTH_USERNAME"),
        password: Cypress.env("BASIC_AUTH_PASSWORD"),
      },
    })

    // example: add the first sandwich to cart
    cy.contains("Add to cart").first().click();

    // go to cart
    cy.visit("/cart");

    // fill order form – must match your form names/ids:
    cy.get('select[name="order[delivery_method]"]').select("self_pickup");
    cy.get('input[name="order[delivery_time]"]').type(
      new Date(Date.now() + 60 * 60 * 1000).toISOString().slice(0, 16) // yyyy-MM-ddTHH:mm
    );
    cy.get('select[name="order[order_status]"]').select("pending");

    // place order
    cy.contains("Place order").click();

    // 3) Verify redirect + flash
    cy.location("pathname").should("eq", "/sandwiches");
    cy.contains("Order placed successfully!").should("be.visible");

    // 4) Verify FaxApp received one more fax
    cy.get("@initialCount").then((initialCount) => {
      cy.request({
        url: `${faxApi}/faxes.json`,
        headers: { Authorization: `Bearer ${faxToken}` },
      }).then((res2) => {
        expect(res2.status).to.eq(200);
        expect(res2.body.length).to.be.greaterThan(initialCount);
      });
    });
  });
});
