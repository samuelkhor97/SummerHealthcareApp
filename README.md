# SummerHealthcareApp
## Backend Setup Local Env 

1. Run `npm install` in the directory of package.json
2. Download PostgreSQL (12 or above): https://www.postgresql.org/download/windows/
3. Download pgAdmin4: https://www.pgadmin.org/download/ 
4. Create local DB with pgAdmin4
5. Use '.env.template' as a template to create the '.env' file (rename '.env.template' to '.env').
6. Inside the '.env' file, set the values (replace the bracketed values)
```
DB_NAME=(yourdbname)
DB_USER=postgres
DB_PASS=(yourpassword)
DB_PORT=5432
DB_HOST=localhost

DB_SYNC=false

PORT=3000
```

7. (seed sample data later to be added)
8. run `npm run dev`

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
