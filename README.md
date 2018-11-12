Class diagram is here:
https://www.lucidchart.com/documents/edit/9a1167b5-ab99-4bae-8180-263492652540/0

1. Oauth2
  - <done> facebook
  - <done> google
  - Twitter - waiting for developer account on twitter
  - <done> Discord

2. <done> Create database migrations/models

3. Create GUI for teams
  - <done> create a new team
  - <done> join an existing team - request/accept/cancel-request/deny
  - <done> kick a team member (captain)
  - <done> quit a team (member) / delete a team (captain)
  - <defer> make my team private (passcode to join)
  - <defer> I have a passcode (join private team)
  - <done> change team captain
  - <done> view team quests
    + <done> quest (started/not-started)
      - <done> steps with status and score-value
        -- hints (available/used) with penalty-value
    + use quest pre-requisites
    + <defer> show random variant - store which variant each team is using (database schema update)
    + <done> display points for whole quest-chain (earned/maximum_available/spent_on_hints)

4. Create GUI for quest creation
  - <done> Quest Name
  - <done> Number of steps
    + <done> step name and number
    + <done> step point value
    + <defer> step variants with unique: body, answer fields
    + <done> step body/answer
    + <defer> step hints
      -- hint number
      -- hint cost
      -- text
    + step pre-requisites (which other quest/steps need to be done before you see this one)
    + <done> publish/unpublish

5. Create scoreboard
  - team, score, spent_on_hints

6. <done> Initial page load
  - <done> if is logged in
    - <done> if has team: load team dashboard
    - <done> else: load team selection
  - <done> login splash screen

7. <done> User preferences
  - <done> set handle (shown on scoreboards and team roster)

8. <done> On team creation, assign all available quests (those with no pre-reqs for step 1)
9. On quest publishing: (after creating steps and pre-reqs)
  - assign to all teams that meet the pre-reqs for step 1
  - <defer> unpublish should ask if we want to keep progress for all teams

10. <done> Add an admin user flag to authorize quest_creation GUI
  - seed admin user
  - admin login page
  - salt/hash password in database
  - change password and name
  - pages to be "admin_only"
    + teams index, destroy, edit, update, export
    + users edit/update should ONLY be from current_user or is_admin
    + quests: all actions
    + steps: all actions

11. <defer> Calculate expected answer from variant.answer and teamquest.seed to get unique answer for each team
12. <cancel> Publish an API to retrieve the calculated expected answer for a specified team/quest/step
13. <defer> Quest Groups - all quests fall into one of 5 static groups (zones, islands, hotels, etc for story purposes).
  - Dashboard shows all groups with:
    - max_quests_available
    - quests_completed_by_my_team
    - quests_completed_by_any_team
    - quests_to_close_this_zone (to push story forward)

14. AWS Integration
  - Quest DB Flag: uses_aws
  - Quest AWS data: json response from lambda startup()
  - Quest info GUI: display AWS connection information
    - recommended platform (windows vs nix)
    - optional AWS interaction instance (IE: IP-address/port to attack)
  - Team DB and GUI - Jumpbox
    - windows and nix
    - jumpbox IP address and creds (pword or PEM)
    - how-to-use-putty URL
    - countdown timer for jumpbox to stay "alive" (with 'Need More Time' button)

15. <done> Dashboard button on top menu bar
16. <done> Answer submission should strip leading/trailing whitespace and do lower-case-comparison


A) pre-reqs
B) AWs integration
C) Scoreboard (overall)
