beforeEach(() => {
  cy.visit("/");
});

it("titles are correct", () => {
  cy.get("title").should(
    "have.text",
    "The Cloud Resume Challenge | giorgiodg.cloud"
  );
  cy.get("h1")
    .invoke("text")
    .then((text) => {
      expect(text.trim()).to.equal("The Cloud Resume Challenge");
    });
});

it("view counter is visualized", () => {
  cy.get("#views").contains("Views:");
});

it("there's a blogpost section and contains a list with at least one item", () => {
  // Selects the second <section> element on the page
  cy.get("section")
    .eq(1)
    .within(() => {
      // Ensure there's at least one <li>
      cy.get("ul > li").its("length").should("be.gte", 1);

      // Check each <li> has an <a> with a non-empty href attribute
      cy.get("ul > li").each(($li) => {
        cy.wrap($li).find("a").should("have.attr", "href").and("not.be.empty");
      });
    });
});

it("there's a section with name and personal links", () => {
  // Selects the third <section> element on the page
  cy.get("section")
    .eq(2)
    .within(() => {
      cy.get("h2")
        .invoke("text")
        .then((text) => {
          expect(text.trim()).to.equal("Giorgio Delle Grottaglie");
        });
    });
});
