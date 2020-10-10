# Project_BirdFlower
This project was built in collaboration with an artist to assist in a 100 day art challenge. For each of the 100 days during the challenge a new unique pair of a bird and a plant is required. This tool assists in discovering, and creating of the unique pairs. By providing large data sets for both categories in addition to ability to save these pairs, it helped to reduce time in research, and left more time for the creation of the artwork. 

BotanicalBirds helps to create these pairs in a variety of ways. There is a simple quick shuffler that returns two random elements including pictures (powered by  the Flickr API) from each respective dataset, with the ability to bookmark that or any other pair, instantly. The user can also swipe through the shuffled, but ordered collection to find the pair that works best. In addition to the shuffler, there are lists available that allow the user to organize and browse through a collection of randomized pairs, birds only, plants only, and of course their bookmarked combinations. From these lists the user can bookmark directly on any element, sort ascending or descending alphabeticly, remove favorites, or search through any of the indiviudal lists. Each item can be viewed within a photo viewer for a closer look as well. 



## Coding Challenges
There was a variety of challenges in creating this project. 

### Finding complete data sets of birds and plants
  
  - My search for RESTful JSON APIs that would return large collections of data for both "Birds" and "Plants" didn't result in much. I was looking for simple robust collections that I could access quickly. When I couldn't find any API that satisfied the, I decided to get my own data and looked into web scraping for what I needed. After some research, and downloading an extension on Chrome to isolate and scrape a website for data, I managed to get a few .CSV files. I then found another tool to convert these .CSV files to JSON and imported that directly into xCode for use by the app.

### Providing an odered set of items while retaining the appearance of being "random"

- Originally, on the shuffle screen of the app, I would simply return a random element from the array of data from the birds and plants collection respectively. Then with both a bird and plant, I perform all of the UI functions to return present it to the user. Each time the shuffle button was hit, it could return a completely random element from the collections. 

This presented a small problem, as things didn't always appear to be random to the user. For example, you could get the same item twice in a row, or in close proximity. Additionally, if the user hit shuffle in error they could easily lose track of what they wanted. To counter this, I refactored the collections to be shuffled on load, and then incremementing the index in each collection, to give the appearance of a randomized collection. I also added swipe gestures to the UIImageViews themselves to allow the user to swipe up and down through the collection in order. 

### Providing the user with a variety of lists to browse, while keeping a clean UI and sensible features that can be easily accessed and intuitively utilized

- When viewing all of the lists in available in the app (Random Pairs, Birds only, Plants only, Favorites), there were a few extra features I wanted to provide so the user can organize and find their inspiration quickly. These features included search, shuffle list, and alphabetically ascending-descending toggle. Providing each of these features on a single screen while also letting the user toggle between lists meant I had to critically think about UI/UX. After some observing some user tests I was able to get a better understanding of the intuitive UI the user expected to find, and adjust accordingly. I decided to provide a menu for each list type to not crowd the screen. A single button for shuffling any list was available in the navigation bar, as well as a ascending-descending toggle. 


