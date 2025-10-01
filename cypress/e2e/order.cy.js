describe("Place order and send fax (local)", () => {
  const faxApi = Cypress.env("FAX_API_URL");
  const faxToken = Cypress.env("FAX_API_TOKEN");

  it("creates an order and posts a fax", () => {
    cy.visit("/sandwiches", {
      auth: {
        username: Cypress.env("BASIC_AUTH_USERNAME"),
        password: Cypress.env("BASIC_AUTH_PASSWORD"),
      },
    })
    cy.get('select[name="shop_id"]').select(1);
    cy.get('input[type="submit"]').contains("Submit").click();

    cy.get('a[href^="/sandwiches/"]').first().click();

    cy.contains("Add to Cart").click();
    cy.wait(500);

    cy.contains("Go to Cart").click();

    const oneHourFromNow = new Date(Date.now() + 60 * 60 * 1000).toISOString().slice(0, 16);

    cy.get('input[name="order[delivery_time]"]').type(oneHourFromNow);

    cy.contains("Place an Order").click();

    cy.location("pathname").should("eq", "/sandwiches");
    cy.contains("Order placed successfully!").should("be.visible");
  });
});
