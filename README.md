# SummerHealthcareApp
## Backend

1. run `npm install` in the directory of package.json
2. Use .env.template as a template to create the .env file, the only things require editing are the local database details.
3. run `npm run start`

## Note
1. Each folder corresponds to a functionality, people responsible for each functionality will write their code in corresponding folder:
    - **admin** -> admin dashboard
    - **healthcareProviders** -> pharmacist view
    - **monitoring** -> sugar levels/weight/Mi band 
    - **users** -> signup/login/authentication/permission
    etc.
2. **helpers** folder to store common helpers function(s) grouped in files.
3. Add your own local files/folders that shouldn't be pushed to repo into .gitignore. e.g. .DS_Store etc
4. There is a most basic endpoint implemented in server.js in /chatroom. It corresponds to http://localhost:3000/api/pingChat in basic configuration.
5. Add in new database entity model in /models after the entities are planned out. Sample entities: User and Message are provided.
