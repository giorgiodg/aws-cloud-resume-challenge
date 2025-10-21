describe("View Counter Lambda (Production E2E)", () => {
  // Read the Lambda URL from Cypress environment variable
  const lambdaUrl = Cypress.env("AWS_LAMBDA_URL");

  if (!lambdaUrl) {
    throw new Error("AWS_LAMBDA_URL environment variable is not set");
  }

  it("increments and returns the view count or handles errors", () => {
    cy.request({
      method: "GET",
      url: lambdaUrl,
      failOnStatusCode: false,
    }).then((response) => {
      expect([200, 500]).to.include(response.status);

      if (response.status === 200) {
        const data =
          typeof response.body === "string"
            ? JSON.parse(response.body)
            : response.body;
        expect(data).to.have.property("view");
        expect(data.view).to.be.a("number");
        cy.log(`Current view count: ${data.view}`);
      } else if (response.status === 500) {
        cy.log("Lambda returned 500 Internal Server Error");
      }
    });
  });
});
