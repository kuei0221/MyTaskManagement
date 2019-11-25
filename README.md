# MyTaskManagement
<<<<<<< HEAD
[![Build Status](https://travis-ci.org/kuei0221/MyTaskManagement.svg?branch=master)](https://travis-ci.org/kuei0221/MyTaskManagement)
=======
>>>>>>> 798c040c1e2b52229f11c7a3cb801abd97bfd73e

Deploy Process (with Heroku)
(Assume you have heroku & github account, and the command run through termian if not other explaination)

1.  install heroku and then login in your terminal < heroku login>
2.  create new project with desired name, otherwise create with random name < heroku create your-project-name >
3. Now you can push your local repo to heroku's git which is generated automatically. < git push heroku master #heroku is just path to the app git, check it with git remote -v whether it exist >
4. If eveything success, then migrate the db with < heroku run rails db:migrate >
5. Then go to heroku website and find your app, link it to your git repo. It will allow the heroku auto deploy the app whenever your linked repo update.
<<<<<<< HEAD
6. Sometime error migth occurr if you forget to migrate the db.
=======
6. Sometime error migth occurr if you forget to migrate the db.
>>>>>>> 798c040c1e2b52229f11c7a3cb801abd97bfd73e
