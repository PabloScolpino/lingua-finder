describe('Home page', () => {
  it.only('has the login button', () => {
    cy.visit('/')

    cy.get('.login-btn')
      .should('have.text', 'Ingresar con Google')
  })
})
