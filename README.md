PRODUCTION:
1. setup database ENV variables
   . ../voyage-aws/env_prod.sh
2. create the database (if not already created)
  rake db:create db:migrate db:seed RAILS_ENV=production
3. precompile the assets
  RAILS_ENV=production bundle exec rake assets:precompile
4. start the web server
  rails s -e production

DEVELOPMENT:
1. setup database ENV variables
  . ../voyage-aws/env_dev.sh
2. create the database (if not already created)
  rake db:create db:migrate db:seed
3. start the web server
  rails s

QUEST creation
1. login as an admin user
  - \sessions\backdoor
  - initial user: porcupine
  - initial password: porcupine69
  - after initial login, click: "settings" and change your username and password.
2. click: "dashboard"
3. Create a quest
4. Edit the quest and add steps
  - recommend numbering steps by 100s so you can insert steps between existing steps
5. Publish the quest.

How does Editing a Quest affect existing teams
1. Adding a step with a step_number lower than the highest step:
  - any team having completed a higher step will auto-complete the inserted step (and get scored for it)
2. Adding a step with a step_number higher than the highest step;
  - all teams will need to do the new step to get scored for the new step
  - this quest is no longer considered "completed" for any team
  - if this quest was a prereq for another quest, then teams who had previously completed this quest will still have access to unlocked quests that were dependent upon this one.  Team who had NOT previously completed this quest will need to finish the new step to unlock dependent quests.
  - You can unpublish and re-publish any quests which use this quest as a prereq to lock dependent quests
3. Change the quest name or any step name
  - immediately updated for all teams
4. Change the step number for any step
  - see #1 and #2 above - this treats this step as a new step.
  - any team who completed this earlier will lose the score for the edited step (but may gain the score back if #1 applies)
5. Delete a prereq for a quest
  - You should unpublish and re-publish the quest to make this quest available to any team meeting the remaining prereqs.
6. Add a prereq for a quest
  - Teams who already began the quest will SAVE their progress and will retain any scores earned.
  - You can unpublish and re-publish the quest to remove availability from any team no-longer meeting the prereqs.
7. Unpublish a quest
  - Teams can no longer view or answer any step of this quest.
  - Earned scores will be retained
  - Progress (completed steps) will be retained (for when it gets published again)
8. Publish a quest
  - Any team meeting the prereqs can view the quest

