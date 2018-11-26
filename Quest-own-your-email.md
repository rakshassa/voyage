Quest-Line-Name: Own Your Email

In <location>, we have discovered an operative named <target-name> who works at a small dental office.
He is expecting an email containing <critical-story-data>.  Let's go get it!

===========
Step Name: Digging up the dirt

Our target is <target-name>.  He works at a small dental office in <location>.
His company's website is here <URL>.
We need to know the name of thier email-administrator so we can dig up some dirt on him.

0. concept: Use public information to determine our attack vector
  - difficulty: easy    score: 2
  - can't login to the web server
  - look at "company info" page to find <email-admin-name>
  - answer-code with the admin-user
  + web server with login link on homepage
  + "company info" page with list of contact info (specific email-admin data)

===========
Step Name: Did you tear your ACL?

In Amazon S3, an Access Control List (ACL) allows you control access to buckets and objects.
When you do not secure your buckets, the data inside those buckets can be leaked.
We have found an S3 bucket containing data backups for PCs owned by <email-admin-name>, the email administrator.
Let's go see what he has in his computer!

1.  concept: Gain access to an S3 bucket with a "backup" of the email-admin's PC/documents folder
  - difficulty: easy   score: 2
  - s3 bucket should have several objects. object name-prefix should be user-name.
  - user-name of <email-admin-name> should have the "passwords.txt" file we need.
  - download and uncompress
  - find "passwords.txt" with an answer code inside.
  + quest requires an s3 bucket with several .zip/.rar/.tar files with user-name prefixes

===========
Step Name: You kept it where!?!

Oooo, that is some juicy stuff!
The dental office hosts their email here: <email-url>
Find a way to login to <target-name> email box and have a look around.

2.  concept: Using the "passwords.txt" login to the company email server as "admin"
  - difficulty: easy   score: 4
  - login as email-admin with password (user-name and password are in the passwords.txt file)
  - reset the password for target user
  - login to target user's email box
  - find answer code inside his unread emails
  + quest requires an email server with specific admin user/password and target-user/password
  + should have a user with answer-code style name??
  + should also have required 2 emails existing in target-user's email box.
    -- 1 email with answer-code
    -- 1 email with URL to private URL download data-file section

===========
Step Name: All Your Emails are belong to me

We know that <target-name> has been expecting an email containing <critical-story-data>.
Find It!

3. concept: Find an email from a private source asking the target-user to download a datafile from a <private-url>
  - difficulty: easy  score: 5
  - <private-url> requires a user-name and password.
  - use "forgot my password" to get a 'reset my password' email.
  - click the 'reset my password' email and set a new password.
    + this should send an email to <email-url> with a 'reset-link' which lets you set a new password.
  - login to the <private-url> with the new password and download the datafile.
  - see an answer-code on the downloads page.
  + requires an app server with name/pword auth (and password-reset email sender)
  + app server should have a download section
  + download section should have an encrypted data-file
  + download section should have an answer-code

===========
Step Name: Crack-a-lack-a

This data file is obviously encrypted.
<hint-for-decryption>

4. concept: Decrypt the datafile
  - difficulty: medium   score: 10
  - find an answer code inside.
  - reveal some <critical-story-data>



