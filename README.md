# mobile-gc-ios

Qwaked is a mobile gift card platform built with a Django backend.

<a href="https://www.youtube.com/watch?v=XQFcVH_k5Mo">View the Demo</a>

<h2>Features/Tech Used</h2>
<ul>
<li>Email verification with Django built-in features.</li>
<li>Stripe Connect for payment processing.</li>
<li>QR Code generation on the backend with <a href="https://github.com/dprog-philippe-docourt/django-qr-code" target="_blank">django-qr-code</a>.</li>
<li>Restful API built with DRF (Django Rest Framework).</li>
<li>Token Authentication system for iOS app authentication.</li>
<li>Swift QR Code Scanner built with the AVFoundation Framework.</li>
</ul>

The general process of the platform is as follows:

<h3>For Merchants</h3>
<ol>
<li>A merchant (a company using the platform) creates their merchant account so they are able to accept payment. Their gift card then becomes available on the site.</li>
<li>Navigating to the /qr/ enpoint of the platform domain, the merchant can generate a QR code for the specified price a customer owes them, and presents the code for the customer to scan.</li>
</ol>

<h3>For Customers</h3>
<ol>
<li>Customers are able to create an account on the platform. An email is sent to their address to verify the account before they can use the platform.</li>
<li>Once verified, the customer can browse the platform's available giftcards. They can choose to send these to a friend (regardless of whether or not they already have an account), or buy a gift card for themself.</li>
<li>Stripe Connect processes the payment for all gift cards the customer buys and immediately pays the merchant their allotted amount while paying the platform it's service fee.</li>
<li>After purchase, all users who receive a gift card are sent an email notification of this update. The card then shows up in their account.</li>
<li>Using the iOS App, customers are able to go into the store they have a mobile gift card for and scan the QR code generated by the merchant to make a purchase.</li>
<li>Then, the purchase price is deducted from the balance on the customer's gift card.</li>
<li>Both the merchant and user are instantaneously notified of any outstanding price still owed after the gift cards are used.</li>
</ol>
