
#!/usr/bin/env bash

#-Project Structure-------------------------------------------------------------

yes no | gradle init \
    --type java-application \
    --dsl kotlin \
    --test-framework junit-jupiter \
    --package "$PROJECT_TITLE" \
    --project-name my-project \
    --no-split-project \
    --java-version 21 \
    --overwrite

# use $PROJECT_TITLE as main class instead of App.Java

cd "./app/src/main/java/$PROJECT_TITLE"
sed "s/App/$PROJECT_TITLE/g" "App.java" > "$PROJECT_TITLE.java"
rm App.java
cd -

cd "./app/src/test/java/$PROJECT_TITLE"
sed "s/App/$PROJECT_TITLE/g" "AppTest.java" > ""$PROJECT_TITLE"Test.java"
rm AppTest.java
cd -

sed "s/$PROJECT_TITLE.App/$PROJECT_TITLE.$PROJECT_TITLE/g" ./app/build.gradle.kts > ./build.gradle.kts.tmp
mv ./build.gradle.kts.tmp ./app/build.gradle.kts


#-Git Ignore--------------------------------------------------------------------

echo "
**/gradlew*
**/*gradle*
**/.settings

**/*.class
*/app/.classpath
*/app/.project
*/.project
" >> .gitignore

