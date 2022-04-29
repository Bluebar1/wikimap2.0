# WikiMap
One of my first Flutter apps. It's main functionality is searching nearby Wikipedia pages from any point on a map. The user will press-and-hold on a point of the map, then WikiMap will use that latitude and longitude to fetch pages from the WikiMedia API. [View WikiMedia API](https://www.mediawiki.org/wiki/API:Main_page). When the pages are loaded, a scroll sheet will appear from the bottom and display information such as the page title, summary, location, distance from search, and all the images on the page. On this scroll sheet, the user can scroll vertically to view all the pages images, or horizontally to view other pages. When the user changes to another page, the Map will automatically animate to the new point and load the new pages information.

## Other Features
* __Start GeoSearch from current location__ - Ask the user for permission to use their devices location, then load that position on the map and search for nearby Wikipedia pages.
* __Saved Pages__ - If you find a page you like and wish to save it for later viewing, store the pageID locally using the [shared_preferences](https://pub.dev/packages/shared_preferences) package.
* __Search Address__ - If you don't want to provide latitude and longitude data for a search, you can enter an address and it will be converted to a location using the [geolocator](https://pub.dev/packages/geolocator) package.
* __Search from Image__ - If you have location services enables on your device and take a picture, the GPS data is stored along with the image in EXIF. Select any of your photos with GPS data to search for nearby Wikipedia pages.

