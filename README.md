# README

Class diagram is here:
https://www.lucidchart.com/documents/edit/9a1167b5-ab99-4bae-8180-263492652540/0
ehj_gm_f1


1. Include twitter oauth
2. Create database migrations/models
3. Create GUI for teams
  - <done> create a new team
  - <done> join an existing team - request/accept/cancel-request/deny
  - <done> kick a team member (captain)
  - <done> quit a team (member) / delete a team (captain)
  - make my team private (passcode to join)
  - I have a passcode (join private team)
  - <done> change team captain

  - view team quests
    + quest (started/not-started) -> steps with status -> hints (available/used)
    + points (earned/maximum_available/spent_on_hints)

4. Create GUI for quest creation
  - Quest Name
  - Number of steps
    + step name and number
    + step point value
    + step variants
      -- text, answer
    + step hints
      -- hint number
      -- hint cost
      -- text

5. Create scoreboard
  - team, score, spent_on_hints

6. Initial page load
  - if has session
    - if has team: load team dashboard
    - else: load team selection
  - login splash screen

7. User preferences
  - set handle (shown on scoreboards and team roster)
