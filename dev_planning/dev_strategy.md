# What brings the most value?

## First Priority
If I'm a start-up with only one client, and their fees will pay the development, what's the minimal product I need to offer?
— an API that creates orders of charge

Which payment method is the most universal, so I can start with it?
— boleto (does not require a bank account, can be done at shops)

Which info should be passed on the request?
- company token
- product token
- client token
- payment method
- payment extra params (boleto -> buyer email address)

What do I need to process the above?
- company registration
- product list
- buyer registration
- offer of payment methods
- config of payment method by seller

## Second Priority
After being able to create orders of charge, it's natural our client can obtain a list of them.
