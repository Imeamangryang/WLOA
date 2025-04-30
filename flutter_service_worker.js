'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"assets/AssetManifest.json": "103423f4d74190aac96426d9eba89c51",
"assets/AssetManifest.bin": "f2dfa7d02c7962ff4e96895caf9cb101",
"assets/assets/example.json": "330fbeff31fb2ac8778f2b02710ecbf0",
"assets/assets/images/raid5.jpg": "b9bb376de57b2b04ad25d910aea14df7",
"assets/assets/images/class24.jpg": "75bdd4edbf4b87e8a8a91b1f1a76e153",
"assets/assets/images/class3.jpg": "0a8845a0e685ef3709860240b11e99e3",
"assets/assets/images/class5.jpg": "6d0c422f9d1032ac1eeb6e63bd2627c0",
"assets/assets/images/class10.jpg": "d68a067ef3cab85c3645b6699b578741",
"assets/assets/images/LOSTARK_wallpaper_3440x1440_Limlake.jpg": "1b8a963670bdcc798e9dd0ba3a8ca46a",
"assets/assets/images/Bg_RaidMain.jpg": "2a769560a839091968631770b9b5d349",
"assets/assets/images/class26.jpg": "9a08c0a6ece6b61e66a768bb4658395a",
"assets/assets/images/class13.jpg": "3049099dfc8b616234e42241e7a0f33a",
"assets/assets/images/class23.jpg": "5f1dad2ed145d1412269be4b98ebf15f",
"assets/assets/images/raid1.jpg": "b9bb376de57b2b04ad25d910aea14df7",
"assets/assets/images/raid0.jpg": "ab33ffc0e947dcb520748cd74e5de884",
"assets/assets/images/class16.jpg": "58666055797938d2b0d39693f75af22e",
"assets/assets/images/class17.jpg": "45792538d5fc025b82a5fddb9ab06072",
"assets/assets/images/class7.jpg": "c9244c8642c297caa8548ae2e93e91e9",
"assets/assets/images/class1.jpg": "2fdf6617dc275f2502274525177d560a",
"assets/assets/images/LOSTARK_wallpaper_3440x1440_Season3.jpg": "68d17d156246dee06f2606787a18ced7",
"assets/assets/images/class8.jpg": "b8b21c595c171265cce51c71ba3c40da",
"assets/assets/images/class19.jpg": "2a3fc801ef7e3fbf124479450e0fa957",
"assets/assets/images/class2.jpg": "4a0cb8c56ea6727a02dc82b6773b6b7c",
"assets/assets/images/class25.jpg": "f3711f09b9b6b8cea2199deb48687b9e",
"assets/assets/images/raid2.jpg": "b70e96699468837f0eca5721b8d674ae",
"assets/assets/images/class9.jpg": "dffff8ce4c7d35de9c23853b5309694a",
"assets/assets/images/class6.jpg": "9a5a601826323400b1ab4bc1912879e0",
"assets/assets/images/class0.jpg": "db2748e529a4accb8af898db5903a914",
"assets/assets/images/NPC.png": "5115cb916e331477c260bca67c7a6966",
"assets/assets/images/raid3.jpg": "273a3c6534e7ae5f89b84f4301b4fd06",
"assets/assets/images/class20.jpg": "b74c977ccfd01b1149eb83767dc643f4",
"assets/assets/images/class18.jpg": "fadc784a3f11163a2a91a56c5c3ed833",
"assets/assets/images/NPC2.png": "fae2186d8e85e382adcfcde29a80d3a2",
"assets/assets/images/raid9.jpg": "462730cb46b47c90bfabcb175b234948",
"assets/assets/images/raid4.jpg": "ab33ffc0e947dcb520748cd74e5de884",
"assets/assets/images/class21.jpg": "19f8b9a951b4d5dfd36c48829fe0d166",
"assets/assets/images/class12.jpg": "91ec5912b3a4f69448f27e00dc682a6e",
"assets/assets/images/class22.jpg": "1df3c77f96daf096be8c9617040fbcd6",
"assets/assets/images/raid6.jpg": "b70e96699468837f0eca5721b8d674ae",
"assets/assets/images/raid7.jpg": "273a3c6534e7ae5f89b84f4301b4fd06",
"assets/assets/images/class15.jpg": "0460da28df033cc65d1869929f88aa4b",
"assets/assets/images/class11.jpg": "946b6ab0a0dda553b959ec3320321727",
"assets/assets/images/class14.jpg": "69f69162f7e3d8aa398f57290a3c3437",
"assets/assets/images/class4.jpg": "110608c04eeb25cf959cec46b9e55f26",
"assets/assets/images/raid8.jpg": "27c3ede5385083e22c8cbd12d00fb85a",
"assets/FontManifest.json": "dc3d03800ccca4601324923c0b1d6d57",
"assets/fonts/MaterialIcons-Regular.otf": "7045b08cbb08be1d2becb9342dfd7be2",
"assets/AssetManifest.bin.json": "7f4a8203a2b25d7cfd81ae0043d28ab1",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"assets/NOTICES": "0bb447c0a3a1c42aa33b1582798cfffd",
"assets/packages/survey_kit/assets/fancy_checkmark.json": "ba198bdf17f5a9a97e89d74c61921edb",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "0640fe71f01ee0bbb7c91d263062883e",
"manifest.json": "f528063836c200689fb6ef62c29b2d70",
"version.json": "ef433564d3991fc3b16b45f04a1402ba",
"flutter.js": "76f08d47ff9f5715220992f993002504",
"canvaskit/chromium/canvaskit.js": "34beda9f39eb7d992d46125ca868dc61",
"canvaskit/chromium/canvaskit.wasm": "64a386c87532ae52ae041d18a32a3635",
"canvaskit/chromium/canvaskit.js.symbols": "5a23598a2a8efd18ec3b60de5d28af8f",
"canvaskit/skwasm.js": "f2ad9363618c5f62e813740099a80e63",
"canvaskit/skwasm.wasm": "f0dfd99007f989368db17c9abeed5a49",
"canvaskit/canvaskit.js": "86e461cf471c1640fd2b461ece4589df",
"canvaskit/skwasm_st.wasm": "56c3973560dfcbf28ce47cebe40f3206",
"canvaskit/canvaskit.wasm": "efeeba7dcc952dae57870d4df3111fad",
"canvaskit/skwasm.js.symbols": "80806576fa1056b43dd6d0b445b4b6f7",
"canvaskit/skwasm_st.js": "d1326ceef381ad382ab492ba5d96f04d",
"canvaskit/canvaskit.js.symbols": "68eb703b9a609baef8ee0e413b442f33",
"canvaskit/skwasm_st.js.symbols": "c7e7aac7cd8b612defd62b43e3050bdd",
"index.html": "b7b7c9c1a675c5af714ec18806d3edda",
"/": "b7b7c9c1a675c5af714ec18806d3edda",
"flutter_bootstrap.js": "c700b2b791e77f53c7e3ecaa6cacd632",
"icons/Icon-192.png": "ac9a721a12bbc803b44f645561ecb1e1",
"icons/Icon-maskable-192.png": "c457ef57daa1d16f64b27b786ec2ea3c",
"icons/Icon-maskable-512.png": "301a7604d45b3e739efc881eb04896ea",
"icons/Icon-512.png": "96e752610906ba2a93c65f8abe1645f1",
"favicon.png": "5dcef449791fa27946b3d35ad8803796",
"main.dart.js": "6777fe39ca35bc0dcc61f18bac62781e"};
// The application shell files that are downloaded before a service worker can
// start.
const CORE = ["main.dart.js",
"index.html",
"flutter_bootstrap.js",
"assets/AssetManifest.bin.json",
"assets/FontManifest.json"];

// During install, the TEMP cache is populated with the application shell files.
self.addEventListener("install", (event) => {
  self.skipWaiting();
  return event.waitUntil(
    caches.open(TEMP).then((cache) => {
      return cache.addAll(
        CORE.map((value) => new Request(value, {'cache': 'reload'})));
    })
  );
});
// During activate, the cache is populated with the temp files downloaded in
// install. If this service worker is upgrading from one with a saved
// MANIFEST, then use this to retain unchanged resource files.
self.addEventListener("activate", function(event) {
  return event.waitUntil(async function() {
    try {
      var contentCache = await caches.open(CACHE_NAME);
      var tempCache = await caches.open(TEMP);
      var manifestCache = await caches.open(MANIFEST);
      var manifest = await manifestCache.match('manifest');
      // When there is no prior manifest, clear the entire cache.
      if (!manifest) {
        await caches.delete(CACHE_NAME);
        contentCache = await caches.open(CACHE_NAME);
        for (var request of await tempCache.keys()) {
          var response = await tempCache.match(request);
          await contentCache.put(request, response);
        }
        await caches.delete(TEMP);
        // Save the manifest to make future upgrades efficient.
        await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
        // Claim client to enable caching on first launch
        self.clients.claim();
        return;
      }
      var oldManifest = await manifest.json();
      var origin = self.location.origin;
      for (var request of await contentCache.keys()) {
        var key = request.url.substring(origin.length + 1);
        if (key == "") {
          key = "/";
        }
        // If a resource from the old manifest is not in the new cache, or if
        // the MD5 sum has changed, delete it. Otherwise the resource is left
        // in the cache and can be reused by the new service worker.
        if (!RESOURCES[key] || RESOURCES[key] != oldManifest[key]) {
          await contentCache.delete(request);
        }
      }
      // Populate the cache with the app shell TEMP files, potentially overwriting
      // cache files preserved above.
      for (var request of await tempCache.keys()) {
        var response = await tempCache.match(request);
        await contentCache.put(request, response);
      }
      await caches.delete(TEMP);
      // Save the manifest to make future upgrades efficient.
      await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
      // Claim client to enable caching on first launch
      self.clients.claim();
      return;
    } catch (err) {
      // On an unhandled exception the state of the cache cannot be guaranteed.
      console.error('Failed to upgrade service worker: ' + err);
      await caches.delete(CACHE_NAME);
      await caches.delete(TEMP);
      await caches.delete(MANIFEST);
    }
  }());
});
// The fetch handler redirects requests for RESOURCE files to the service
// worker cache.
self.addEventListener("fetch", (event) => {
  if (event.request.method !== 'GET') {
    return;
  }
  var origin = self.location.origin;
  var key = event.request.url.substring(origin.length + 1);
  // Redirect URLs to the index.html
  if (key.indexOf('?v=') != -1) {
    key = key.split('?v=')[0];
  }
  if (event.request.url == origin || event.request.url.startsWith(origin + '/#') || key == '') {
    key = '/';
  }
  // If the URL is not the RESOURCE list then return to signal that the
  // browser should take over.
  if (!RESOURCES[key]) {
    return;
  }
  // If the URL is the index.html, perform an online-first request.
  if (key == '/') {
    return onlineFirst(event);
  }
  event.respondWith(caches.open(CACHE_NAME)
    .then((cache) =>  {
      return cache.match(event.request).then((response) => {
        // Either respond with the cached resource, or perform a fetch and
        // lazily populate the cache only if the resource was successfully fetched.
        return response || fetch(event.request).then((response) => {
          if (response && Boolean(response.ok)) {
            cache.put(event.request, response.clone());
          }
          return response;
        });
      })
    })
  );
});
self.addEventListener('message', (event) => {
  // SkipWaiting can be used to immediately activate a waiting service worker.
  // This will also require a page refresh triggered by the main worker.
  if (event.data === 'skipWaiting') {
    self.skipWaiting();
    return;
  }
  if (event.data === 'downloadOffline') {
    downloadOffline();
    return;
  }
});
// Download offline will check the RESOURCES for all files not in the cache
// and populate them.
async function downloadOffline() {
  var resources = [];
  var contentCache = await caches.open(CACHE_NAME);
  var currentContent = {};
  for (var request of await contentCache.keys()) {
    var key = request.url.substring(origin.length + 1);
    if (key == "") {
      key = "/";
    }
    currentContent[key] = true;
  }
  for (var resourceKey of Object.keys(RESOURCES)) {
    if (!currentContent[resourceKey]) {
      resources.push(resourceKey);
    }
  }
  return contentCache.addAll(resources);
}
// Attempt to download the resource online before falling back to
// the offline cache.
function onlineFirst(event) {
  return event.respondWith(
    fetch(event.request).then((response) => {
      return caches.open(CACHE_NAME).then((cache) => {
        cache.put(event.request, response.clone());
        return response;
      });
    }).catch((error) => {
      return caches.open(CACHE_NAME).then((cache) => {
        return cache.match(event.request).then((response) => {
          if (response != null) {
            return response;
          }
          throw error;
        });
      });
    })
  );
}
