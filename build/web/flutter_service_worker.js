'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';
const RESOURCES = {
  "assets/AssetManifest.json": "e840e0b90ed214b26083c3bafd6921ba",
"assets/assets/analysis_01.jpg": "a770872a3792816e086ae53fa5ffb884",
"assets/assets/analysis_02.jpg": "02f4adb9a51cb5873bfd444b21ee57f6",
"assets/assets/analysis_03.jpg": "dd88515d6d0bc5be7f07522bcf340f07",
"assets/assets/analysis_04.jpg": "96f18806cf74ad948817ebe68e179742",
"assets/assets/analysis_05.jpg": "d742e19155dea72ce905b37cc9481b01",
"assets/assets/avatar_01.png": "faf93c303e6bf3c29168a2a17c37c3ac",
"assets/assets/bg_01.jpg": "22ae6be15b231d64d750e4402b08423f",
"assets/assets/bg_02.jpg": "5ed87fe70ded44ab6430d992c3fd2c84",
"assets/assets/bg_03.jpg": "cfe4bc823616ed6585e3a922eaaeaf20",
"assets/assets/bg_04.jpg": "a245b5e95777b6d7c950f2526ca4b536",
"assets/assets/bg_05.jpg": "4a8bc27adbf0762bd2959841f521e761",
"assets/assets/bg_nic.jpg": "85d5221f2066a79f2bd4b9b3ee1bdb0a",
"assets/assets/biosci_logo.png": "1e780b19d8f0f57e88565e714291ab39",
"assets/assets/bisgroup-logo.png": "6e59511568a3e668fd6ac77af7345ed7",
"assets/assets/bisgroup_logo_contrast.png": "a1855b2bd6bf46b9fd43481e3f8de43f",
"assets/assets/bisgroup_logo_white.png": "6f8effcf0188a4296e0adaea617dea3c",
"assets/assets/business_click.jpg": "6f78e29d9075ef68917afaac512f9fd3",
"assets/assets/business_drawing.jpg": "3c00abdc873f24ae7f878cf8c63f22a9",
"assets/assets/business_inventory.jpg": "c212c077e202ba266bed0f6152e4eef0",
"assets/assets/business_marketing.jpg": "1f1a7039c94819911dc2e8c85fb40919",
"assets/assets/business_support.jpg": "8cdb0f6ca3f6b8a64a0623bcf0e149c6",
"assets/assets/cloud_01.jpg": "7345670e89232239da8e73db0196f885",
"assets/assets/cloud_02.jpg": "99d363df0970cf540449eb09a7c1f99e",
"assets/assets/goods_return.jpg": "13031c197822d11b7196e5fca71176bc",
"assets/assets/new-bisgroup-logo.png": "25c6b280478356eece3c16e71b786d8d",
"assets/assets/order_01.jpg": "9c7097b8013222c5f4e0aecf870409e9",
"assets/assets/order_02.jpg": "dd029af99d69fc72ea7576f62ccbabf2",
"assets/assets/shakehand_01.jpg": "7f250012970c6939607fd41cf03baf1d",
"assets/assets/shakehand_02.jpg": "f782fe6f00082d4d9078812a3d7f89eb",
"assets/assets/shakehand_03.jpg": "12207c4062f35422b626fb55c5da08ac",
"assets/assets/work_schedule.jpg": "b20611a5240ea13c207366f8b4611dc5",
"assets/assets/work_schedule_02.jpg": "97c5fa9526c6fa7cb73940f433550d47",
"assets/assets/work_schedule_03.jpg": "147a378483af51f64117c205c5f8b2ad",
"assets/FontManifest.json": "5a32d4310a6f5d9a6b651e75ba0d7372",
"assets/fonts/MaterialIcons-Regular.otf": "1288c9e28052e028aba623321f7826ac",
"assets/NOTICES": "b959f28a4d9c27b1ae598ee7405c9f60",
"assets/packages/awesome_dialog/assets/flare/error.flr": "87d83833748ad4425a01986f2821a75b",
"assets/packages/awesome_dialog/assets/flare/error_without_loop.flr": "35b9b6c9a71063406bdac60d7b3d53e8",
"assets/packages/awesome_dialog/assets/flare/info.flr": "bc654ba9a96055d7309f0922746fe7a7",
"assets/packages/awesome_dialog/assets/flare/info2.flr": "21af33cb65751b76639d98e106835cfb",
"assets/packages/awesome_dialog/assets/flare/info_without_loop.flr": "cf106e19d7dee9846bbc1ac29296a43f",
"assets/packages/awesome_dialog/assets/flare/question.flr": "1c31ec57688a19de5899338f898290f0",
"assets/packages/awesome_dialog/assets/flare/succes.flr": "ebae20460b624d738bb48269fb492edf",
"assets/packages/awesome_dialog/assets/flare/succes_without_loop.flr": "3d8b3b3552370677bf3fb55d0d56a152",
"assets/packages/awesome_dialog/assets/flare/warning.flr": "68898234dacef62093ae95ff4772509b",
"assets/packages/awesome_dialog/assets/flare/warning_without_loop.flr": "c84f528c7e7afe91a929898988012291",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "115e937bb829a890521f72d2e664b632",
"assets/packages/fluttertoast/assets/toastify.css": "a85675050054f179444bc5ad70ffc635",
"assets/packages/fluttertoast/assets/toastify.js": "e7006a0a033d834ef9414d48db3be6fc",
"assets/packages/font_awesome_flutter/lib/fonts/fa-brands-400.ttf": "00bb2b684be61e89d1bc7d75dee30b58",
"assets/packages/font_awesome_flutter/lib/fonts/fa-regular-400.ttf": "4b6a9b7c20913279a3ad3dd9c96e155b",
"assets/packages/font_awesome_flutter/lib/fonts/fa-solid-900.ttf": "dffd9504fcb1894620fa41c700172994",
"assets/packages/rich_alert/assets/error.png": "94b47e3843f8944e5a1e506a8322c060",
"assets/packages/rich_alert/assets/success.png": "da188ccb78f1017e9645542bb5e52d6b",
"assets/packages/rich_alert/assets/warning.png": "46a6a5aec20dda0d32db925d57bf00d3",
"favicon.png": "5dcef449791fa27946b3d35ad8803796",
"icons/Icon-192.png": "ac9a721a12bbc803b44f645561ecb1e1",
"icons/Icon-512.png": "96e752610906ba2a93c65f8abe1645f1",
"index.html": "d9b88de4599bc7a88d425ab02a7c4a2e",
"/": "d9b88de4599bc7a88d425ab02a7c4a2e",
"main.dart.js": "2e96b37e420d6ec03633463a8729013d",
"manifest.json": "f65bc21bef687ba843b62d6ad91e8763",
"version.json": "c9fefdb48ba3d2c8bc4f3aa6e2b7b5fa"
};

// The application shell files that are downloaded before a service worker can
// start.
const CORE = [
  "/",
"main.dart.js",
"index.html",
"assets/NOTICES",
"assets/AssetManifest.json",
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
        // lazily populate the cache.
        return response || fetch(event.request).then((response) => {
          cache.put(event.request, response.clone());
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
