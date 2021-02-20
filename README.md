# SummerHealthcareApp (Frontend)

## Get Started
1. Please first watch the full video tutorial on the basics of Flutter (It will provide sufficient knowledge for developers to familiarize themselves with this framework e.g. how to setup Flutter and Android Studio, how to download all dependencies before running the actual code base and more!)

2. There are also tutorials on how to setup the Firebase SHA1 key installation in order to use Firebase services on your testing device

3. If there is an update to Flutter, a video tutorial is also available to guide developers on how to update their Flutter version

## Coding Standards
1. All general constant fields should be added into the constants.dart file provided under the 'lib' directory. This is to ensure that the constants are kept in one place and allows for easy refactoring and accessibility (Do have a look around the code base to familiarize yourself with it before starting any development)

2. There is also a widgets.dart file that was created in the 'widgets' directory, this file should only contain exports for widgets in the directory, an example is given in the file itself so feel free to reference it! (By just importing one file, you can have access to all the widgets in the widgets directory, there is no need to import each widget one by one. (remember also whenever u create a widget please add the export command to the widgets file too)
