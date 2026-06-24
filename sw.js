// LogTrain — Service Worker
// Responsável pelo cache offline e instalação como PWA

const CACHE_NAME = 'logtrain-v1';
const FONTS_CACHE = 'logtrain-fonts-v1';

// Arquivos essenciais para funcionar offline
const CORE_ASSETS = [
  './',
  './index.html',
  './manifest.json',
];

// ---- Install: pré-cacheia os arquivos principais ----
self.addEventListener('install', (event) => {
  event.waitUntil(
    caches.open(CACHE_NAME)
      .then(cache => cache.addAll(CORE_ASSETS))
      .then(() => self.skipWaiting())
  );
});

// ---- Activate: limpa caches antigos ----
self.addEventListener('activate', (event) => {
  event.waitUntil(
    caches.keys().then(keys =>
      Promise.all(
        keys
          .filter(k => k !== CACHE_NAME && k !== FONTS_CACHE)
          .map(k => caches.delete(k))
      )
    ).then(() => self.clients.claim())
  );
});

// ---- Fetch: serve do cache, com fallback para rede ----
self.addEventListener('fetch', (event) => {
  const url = new URL(event.request.url);

  // Supabase e CDN externo: sempre vai para rede (não cacheia dados dinâmicos)
  if (
    url.hostname.includes('supabase.co') ||
    url.hostname.includes('googleapis.com') ||
    url.hostname.includes('gstatic.com') ||
    url.hostname.includes('tailwindcss.com') ||
    url.hostname.includes('jsdelivr.net')
  ) {
    // Cache de fontes e CDN com stale-while-revalidate
    if (url.hostname.includes('googleapis.com') || url.hostname.includes('gstatic.com')) {
      event.respondWith(
        caches.open(FONTS_CACHE).then(cache =>
          cache.match(event.request).then(cached => {
            const network = fetch(event.request).then(response => {
              cache.put(event.request, response.clone());
              return response;
            });
            return cached || network;
          })
        )
      );
      return;
    }
    // Para Supabase: só rede
    return;
  }

  // App shell: cache-first
  event.respondWith(
    caches.match(event.request).then(cached => {
      if (cached) return cached;
      return fetch(event.request).then(response => {
        if (response.ok) {
          caches.open(CACHE_NAME).then(c => c.put(event.request, response.clone()));
        }
        return response;
      }).catch(() => caches.match('./index.html'));
    })
  );
});
