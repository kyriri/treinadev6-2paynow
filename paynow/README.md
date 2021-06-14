# PAYNOW - A payment platform

The command `$ rails notes -a OBS` lists simplifications of business rules done during development.

## API usage

### Creating a standalone charge order
![POST](https://img.shields.io/badge/-POST-blue "POST")  
`/api/v1/charge_orders/`

#### - Data Params
```
{
  charge_order: {
    company_token: "ReMbUPJUM1LRjAA7tVos6SXY",
    client_token: "kvbGRSUCWvFFVMKf3SxedNei", 
    product_token: "w7dc1MjzWyoUHGQvSo1fphLL",
    payment_type_token: "5bvTKWUnuUCaTwJu4dYbwcH6",
    due_date: '2021-06-25',
    buyer_email: 'svalbard_bear@coldmail.com',
  }
}
```
(`due_date` follows the format YYYY-MM-DD)
  
#### - Success Response:
![201: Created](https://img.shields.io/badge/Code:%20201-CREATED-green "201: Created")  
`{ "charge_order_token": "hEdK2gqcCX8pPmA9yp5ura8j" } `
  
#### - Error Response:
![401: Unauthorized access](https://img.shields.io/badge/Code:%20401-UNAUTHORIZED%20ACCESS-red "401: Unauthorized access")  
Token is expired, blocked, or absent from the database.  
` { "error": "Invalid company token" } `
  
![412: Parameters missing](https://img.shields.io/badge/Code:%20412-PARAMS%20MISSING-red "412: Parameters missing")  
At least one mandatory parameter was absent. Check message for details. Example:  
` { "error": "Costumer email absent" }`
  
![422: Wrongful parameters](https://img.shields.io/badge/Code:%20422-WRONGFUL%20PARAMS-red "422: Wrongful parameters")  
At least one parameter was invalid. Check message for details. Example:  
` { "error": "Payment due date cannot be in the past" } `
  
--- 
This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

* Ruby version

* System dependencies

* Configuration

* Database creation

* Database initialization

* How to run the test suite

* Services (job queues, cache servers, search engines, etc.)

* Deployment instructions

* ...
