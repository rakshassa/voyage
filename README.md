Class diagram is here:
https://www.lucidchart.com/documents/edit/9a1167b5-ab99-4bae-8180-263492652540/0

1. Oauth2
  - <done> facebook
  - <done> google
  - Twitter
  - Discord

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
    + show random variant - store which variant each team is using (database schema update)
    + <done> display points for whole quest-chain (earned/maximum_available/spent_on_hints)

4. Create GUI for quest creation
  - <done> Quest Name
  - <done> Number of steps
    + <done> step name and number
    + <done> step point value
    + step variants
      -- text, answer
    + step hints
      -- hint number
      -- hint cost
      -- text
    + step pre-requisites (which other quest/steps need to be done before you see this one)
    + <done> publish/unpublish

5. Create scoreboard
  - team, score, spent_on_hints

6. Initial page load
  - <done> if is logged in
    - <done> if has team: load team dashboard
    - <done> else: load team selection
  - <done> login splash screen

7. User preferences
  - set handle (shown on scoreboards and team roster)

8. On team creation, assign all available quests (those with no pre-reqs for step 1)
9. On quest publishing: (after creating steps and pre-reqs)
  - assign to all teams that meet the pre-reqs for step 1
  - unpublish should ask if we want to keep progress for all teams

10. Add an admin user flag to authorize quest_creation GUI
11. Calculate expected answer from variant.answer and teamquest.seed to get unique answer for each team
12. Publish an API to retrieve the calculated expected answer for a specified team/quest/step
