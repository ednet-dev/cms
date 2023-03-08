Concept: User
Attributes: ID, name, email, password
Relationships:
Many-to-many relationship with Issue: A user can vote on multiple issues, and multiple users can vote on the same issue.
One-to-many relationship with Comment: A user can make multiple comments, but a comment is made by only one user.
Concept: Issue
Attributes: ID, title, description, options
Relationships:
Many-to-many relationship with User: An issue can be voted on by multiple users, and a user can vote on multiple issues.
One-to-many relationship with Comment: An issue can have multiple comments, but a comment belongs to only one issue.
Concept: Comment
Attributes: ID, text, timestamp
Relationships:
Many-to-one relationship with User: A comment is made by one user, but a user can make multiple comments.
Many-to-one relationship with Issue: A comment belongs to one issue, but an issue can have multiple comments.
Using EDNetCore, we could generate code for these concepts and their relationships, as well as actions for adding, updating, and deleting data. We could also easily navigate through the data, for example:

Given a User ID, we could retrieve all the Issues they have voted on.
Given an Issue ID, we could retrieve all the Users who have voted on that issue and all the Comments made on that issue.
Given a Comment ID, we could retrieve the User who made the comment and the Issue the comment belongs to.