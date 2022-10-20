describe('Login', () => {
  it.only('can login and log out', () => {
    cy.fixture('google_user').then((user_json)=>{
      cy.app('google_oauth2_mock', user_json)
    })

    cy.visit('/')

    cy.get('[data-cy=login]').click()
    cy.get('nav').get('[data-cy="logout"]').click()
  })
})
