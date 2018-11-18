Class diagram is here:
https://www.lucidchart.com/documents/edit/9a1167b5-ab99-4bae-8180-263492652540/0

1. Oauth2
  - <done> facebook
  - <done> google
  - <defer> Twitter - waiting for developer account on twitter
  - <done> Discord

2. <done> Create database migrations/models

3. Create GUI for teams
  - <done> create a new team
  - <done> join an existing team - request/cancel-request
  - <done> team captain can accept/deny join requests
  - <done> kick a team member (captain)
  - <done> quit a team (member) / delete a team (captain)
  - <defer> make my team private (passcode to join)
  - <defer> I have a passcode (join private team)
  - <done> change team captain
  - <done> view team quests
    + <done> quest (started/not-started)
      - <done> steps with status and score-value
        -- <defer> hints (available/used) with penalty-value
    + <done> use quest pre-requisites
      - <done> do not view in quest dashboard when prereqs not met
      - <done> do not allow quest view/answer in controller
    + <done> separate GUI section for completed quests
    + <done> allow viewing completed steps
    + <defer> show random variant - db store which variant each team is using
    + <done> display points for whole quest-chain (earned/maximum_available/spent_on_hints)
    + <done> display team roster
    + <done> display join requests to leader unless team is full
    + <done> indicate team captain
    + <done> indicate max team size
    + <done> Team captain can ignore join-requests when team is NOT full but doesn't want more teammates.
    + <done> Team captain can stop ignoring join-requests

4. Create GUI for quest creation
  - <done> Quest Name
  - <done> Number of steps
    + <done> step name and number
    + <done> step point value
    + <defer> step variants with unique: body, answer fields
    + <done> step body/answer
    + <defer> step hints: hint-number, cost, text
    + <done> step pre-requisites (which other quest need to be done before you see this one)
      - <done> prereq model
      - <done> GUI to select/view/edit/remove list of prereq quests
    + <done> publish/unpublish

5. <done> Create scoreboard
  - <done> team, score
  - <defer> spent_on_hints

6. <done> Initial page load
  - <done> if is logged in
    - <done> if has team: load team dashboard
    - <done> else: load team selection
  - <done> login splash screen

7. <done> User preferences
  - <done> set handle (shown on scoreboards and team roster)

8. <done> On team creation, assign all available quests (those with no pre-reqs for step 1)
9. <done> On quest publishing: (after creating steps and pre-reqs)
  - <done> assign to all teams that meet the pre-reqs for step 1
  - <defer> unpublish should ask if we want to keep progress for all teams

10. <done> Add an admin user flag to authorize quest_creation GUI
  - <done>seed admin user
  - <done>admin login page
  - <done>salt/hash password in database
  - <done>change password and name
  - <done>pages to be "admin_only"
    + <done>teams index, destroy, edit, update, export
    + <done>users edit/update should ONLY be from current_user or is_admin
    + <done>quests: all actions
    + <done>steps: all actions

11. <defer> Calculate expected answer from variant.answer and teamquest.seed to get unique answer for each team
12. <defer> Rest API
13. <defer> Quest Groups - all quests fall into one of 5 static groups
  - <defer> ex: zones, islands, hotels, etc for story purposes
  - <defer> Dashboard shows all groups with:
    - <defer> max_quests_available
    - <defer> quests_completed_by_my_team
    - <defer> quests_completed_by_any_team
    - <defer> quests_to_close_this_zone (to push story forward)

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
16. <done> Answer submission
    - <done> should strip leading/trailing whitespace
    - <done> lower-case-comparison
17. <done> Database export to flat files (to save quests/steps/users/teams)
  - <done> database import from flat files
18. <defer> consider removing teamquest.status and just calculating with:
  - <defer> quest.is_published && quest.all_prereqs_done(team)

