importScripts("https://www.gstatic.com/firebasejs/8.10.0/firebase-app.js");
importScripts("https://www.gstatic.com/firebasejs/8.10.0/firebase-messaging.js");

firebase.initializeApp({
      apiKey: "AIzaSyB8ZAFd5Sr9DpXS1mYZVvM33wN6ZWpnCGQ",
      authDomain: "alrafayah2026-a9c37.firebaseapp.com",
      projectId: "alrafayah2026-a9c37",
      storageBucket: "alrafayah2026-a9c37.firebasestorage.app",
      messagingSenderId: "766014068058",
      appId: "1:766014068058:android:e5f19e86455dd6a2504f63",
});
const messaging = firebase.messaging();

messaging.setBackgroundMessageHandler(function (payload) {
    const promiseChain = clients
        .matchAll({
            type: "window",
            includeUncontrolled: true
        })
        .then(windowClients => {
            for (let i = 0; i < windowClients.length; i++) {
                const windowClient = windowClients[i];
                windowClient.postMessage(payload);
            }
        })
        .then(() => {
            const title = payload.notification.title;
            const options = {
                body: payload.notification.score
              };
            return registration.showNotification(title, options);
        });
    return promiseChain;
});
self.addEventListener('notificationclick', function (event) {
    console.log('notification received: ', event)
});
