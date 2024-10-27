describe('template spec', () => {
  it('passes', () => {
    cy.visit('http://localhost:8000/auth')
    cy.get('#email').type('admin_Batman@admin.com')
    cy.get('#password').type('admin12345')
    cy.get('button[type="submit"]').click() 
    cy.wait(5000)
    cy.get('#week').click()
    cy.get('#month').click()
  })
})