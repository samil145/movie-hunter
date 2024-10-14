![](https://github.com/samil145/movie-hunter/blob/master/Images/MovieHunter.png?raw=true)

# Movie Hunter

**Movie Hunter** is an IOS app about movies. **Trending, upcoming movies/TV series** are in this app for you discovering them. You can **search** for movies, get detailed information about them and **cast & crew**, watch **trailer** of movie and add movies to **favorites** section. Moreover, this app provides users with **authentication** system. 

## ⛓ Features

- When the app is launched, user should **register**. There is also "**Forgot Password**" option for resetting password.

<p align="center">
<img src= "https://github.com/samil145/movie-hunter/blob/master/Images/login.png?raw=true" height="600" >
&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;
<img src= "https://github.com/samil145/movie-hunter/blob/master/Images/forgot_password.png?raw=true" height="600">
</p>

- After authentication process, home screen will pop up. Here, user can discover **trending, upcoming, top rated** Movies/TV Series. Moreover, with tapping on app icon on top left corner, user can access **menu**. **Signing out** and more navigation operations could be done here.

<p align="center">
<img src= "https://github.com/samil145/movie-hunter/blob/master/Images/home.png" height="600" >
&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;
<img src= "https://github.com/samil145/movie-hunter/blob/master/Images/menu.png" height="600">
</p>

- For **searching movies**, search icon on top right corner of home screen should be tapped on. **Pagination system** is applied for more search results.

<p align="center">
<img src= "https://github.com/samil145/movie-hunter/blob/master/Images/search.gif?raw=true" height="600" width="300">
</p> 

- User can get **detailed information** about movie/TV series with tapping on them on home, search, favorites screen. Here, user can discover **rating, genres, overview, cast and crew** of movie. Additionally, tapping on YouTube logo will lead to YouTube application to watch **trailer** (or web if application does not exist).
- App provides users with **favorites** section. Users can select their favorite movie by tapping on **star icon** on movie info screen. Bottom part of screen (tab bar) navigates users to home or favorites screen.
  
<p align="center">
<img src= "https://github.com/samil145/movie-hunter/blob/master/Images/info.png?raw=true" height="600" >
&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;
<img src= "https://github.com/samil145/movie-hunter/blob/master/Images/movieInfoVC.gif?raw=true" height="600" width="300">
</p>

## Technical Background
- **Movie Hunter** is made with **"UIKit"** framework.
- **Authentication system** is developed with **Firestore(Firebase)**.
- **"The Movie Database"(TMDB)** is used for API calls.
- **MVC** is applied.
