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


## Adding Food Data Info into Database:
1. Download food_calories csv file from google drive (Healthcare App google drive)

2. Go to your window's search and search for "psql" (It looks like a terminal and it's called "SQL Shell (psql)" OR
Go to your PostgreSQL file and open it through there also works.

3. It will prompt you something to type, enter the following data (replace the bracket value to your own value):

```
Server [localhost]: localhost
Database [postgres]: (your db name)
Port[5432]: 5432
Username [postgres]: postgres
Password for user postgres: (your password)
```

4. Once success, enter/copy the following code into the terminal (replace the bracket value to the location where the csv file is located):

```
\COPY public."Food_Data"(food_id, food_name, calories, protein, total_fat, saturated_fat, dietary_fibre, carbohydrate, cholesterol, sodium), FROM ('C:\Users\User\Desktop\food_calories.csv') DELIMITER ',' CSV HEADER;
```

5. Done


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
