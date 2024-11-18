# WebView-iOS-SDK

Initialize a Git repository and push the package to a remote repository (e.g., GitHub).
git init
git add .
git commit -m "Initial commit"
git branch -M main
git remote add origin <repository-url>
git push -u origin main


Add a Git Tag:
SPM uses tags to identify versions.
git tag 1.0.0
git push origin 1.0.0

Test Package Integration:
In another project, add the SDK using SPM:
In Xcode, go to File > Add Packages.
Enter the GitHub URL for your SDK.
