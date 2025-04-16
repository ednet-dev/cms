part of ednet_core;

bool randomBool() => Random().nextBool();

double randomDouble(num max) => Random().nextDouble() * max;

int randomInt(int max) => Random().nextInt(max);

num randomNum(int max) {
  var logic = randomBool();
  var sign = randomSign();
  if (logic) {
    return sign * randomInt(max);
  } else {
    return sign * randomDouble(max);
  }
}

randomSign() {
  int result = 1;
  var random = randomInt(10);
  if (random == 0 || random == 5 || random == 10) {
    result = -1;
  }
  return result;
}

String randomWord() => randomListElement(wordList);

String randomUri() => randomListElement(uriList);

String randomEmail() => randomListElement(emailList);

String randomQuote() => randomListElement(quotes);

randomListElement(List list) => list[randomInt(list.length - 1)];

var wordList = [
  'home',
  'train',
  'holiday',
  'cup',
  'coffee',
  'cream',
  'architecture',
  'judge',
  'wife',
  'ship',
  'ocean',
  'fish',
  'drink',
  'beer',
  'software',
  'pattern',
  'children',
  'plate',
  'room',
  'milk',
  'lunch',
  'dinner',
  'web',
  'service',
  'body',
  'money',
  'smog',
  'guest',
  'cinema',
  'series',
  'wave',
  'river',
  'nothingness',
  'hot',
  'small',
  'instruction',
  'cloud',
  'consulting',
  'beach',
  'place',
  'big',
  'tall',
  'teaching',
  'ball',
  'circle',
  'explanation',
  'music',
  'kids',
  'month',
  'time',
  'line',
  'horse',
  'abstract',
  'revolution',
  'college',
  'concern',
  'house',
  'tent',
  'paper',
  'letter',
  'hospital',
  'debt',
  'undo',
  'family',
  'car',
  'auto',
  'restaurant',
  'present',
  'parfem',
  'bank',
  'redo',
  'fascination',
  'truck',
  'blue',
  'accident',
  'policeman',
  'advisor',
  'interest',
  'authority',
  'park',
  'city',
  'craving',
  'accomodation',
  'account',
  'do',
  'school',
  'country',
  'call',
  'cabinet',
  'element',
  'call',
  'center',
  'selfdo',
  'teacher',
  'message',
  'text',
  'job',
  'table',
  'tape',
  'price',
  'discount',
  'marriage',
  'word',
  'tag',
  'saving',
  'cable',
  'sand',
  'darts',
  'autobus',
  'feeling',
  'tree',
  'flower',
  'employer',
  'understanding',
  'camping',
  'pub',
  'heaven',
  'beans',
  'rice',
  'effort',
  'umbrella',
  'distance',
  'mile',
  'selfie',
  'hell',
  'brad',
  'water',
  'taxi',
  'season',
  'seed',
  'brave',
  'meter',
  'done',
  'void',
  'yellow',
  'lake',
  'energy',
  'tax',
  'heating',
  'crisis',
  'measuremewnt',
  'point',
  'deep',
  'corner',
  'hunting',
  'dog',
  'sailing',
  'beginning',
  'agile',
  'slate',
  'wheat',
  'pencil',
  'enquiry',
  'salad',
  'salary',
  'vacation',
  'plaho',
  'baby',
  'computer',
  'algorithm',
  'edition',
  'television',
  'highway',
  'winter',
  'life',
  'performance',
  'productivity',
  'economy',
  'tension',
  'health',
  'top',
  'knowledge',
  'picture',
  'photo',
  'entertainment',
  'team',
  'capacity',
  'notch',
  'walking',
  'phone',
  'bird',
  'oil',
  'organization',
  'election',
  'grading',
  'mind',
  'boat',
  'question',
  'electronic',
  'entrance',
  'head',
  'privacy',
  'finger',
  'answer',
  'sentence',
  'candy',
  'output',
  'hat',
  'security',
  'ticket',
  'vessel',
  'book',
  'message',
  'navigation',
  'cash',
  'office',
  'east',
  'unit',
  'consciousness',
  'video',
  'email',
  'observation',
  'objective',
  'chemist',
  'up',
  'girl',
  'agreement',
  'training',
  'test',
  'opinion',
  'offence',
  'down',
  'test',
  'time',
  'course',
  'school',
  'hall',
  'celebration',
  'thing',
  'left',
  'future',
  'universe',
  'university',
  'professor',
  'cardboard',
  'dvd',
  'theme',
  'right',
  'lifespan',
  'sun',
  'sin',
  'chairman',
  'executive',
  'secretary',
  'end',
  'now',
];

var uriList = [
  'http://www.useit.com/alertbox/articles-not-blogs.html',
  'http://cci.mit.edu/ci2012/plenaries/index.html',
  'http://www.typescriptlang.org/',
  'http://whoapi.com/',
  'http://news.ycombinator.com/item?id=4530217',
  'http://www.pythontutor.com/',
  'https://github.com/languages/Dart',
  'http://www.drdobbs.com/open-source/dart-build-html5-apps-fast/240005631',
  'http://darttrials.blogspot.ca/2012/09/contributed-contributions.html',
  'http://kkovacs.eu/cassandra-vs-mongodb-vs-couchdb-vs-redis',
  'http://code.google.com/p/dart-enumerators/',
  'http://gsdview.appspot.com/dart-editor-archive-continuous/latest/',
  'http://www.villa-marrakech.ma/',
  'http://www.dartlang.org/articles/idiomatic-dart/',
  'http://dartery.blogspot.ca/2012/09/memoizing-functions-in-dart.html',
  'http://blog.dynamicprogrammer.com/2012/09/01/first-steps-with-dart.html',
  'http://www.dartlang.org/',
  'https://github.com/dart-lang',
  'http://pub.dartlang.org/',
  'http://www.builtwithdart.com/',
  'http://www.drdobbs.com/open-source/dart-build-html5-apps-fast/240005631',
  'https://code.google.com/p/dart/',
  'https://groups.google.com/a/dartlang.org/forum/?fromgroups#!forum/misc',
  'https://groups.google.com/a/dartlang.org/forum/?fromgroups#!forum/web-ui',
  'http://www.dartlang.org/support/',
  'http://code.google.com/p/dart/issues/list',
  'http://try.dartlang.org/',
  'http://www.dartlang.org/articles/style-guide/',
  'http://code.google.com/p/dart/wiki/Contributing',
  'http://news.dartlang.org/2012/08/tracking-darts-m1-progress.html',
  'http://www.dartlang.org/articles/m1-language-changes/',
  'https://github.com/dart-lang',
  'http://blog.dartwatch.com/p/community-dart-packages-and-examples.html',
  'http://api.dartlang.org/docs/continuous/',
  'http://www.dartlang.org/articles/style-guide/',
  'http://hilite.me/',
  'http://jsonformatter.curiousconcept.com/',
  'http://stackoverflow.com/tags/dart',
  'http://www.dartlang.org/articles/m1-language-changes/',
  'http://www.dartlang.org/articles/dart-unit-tests/',
  'http://www.dartlang.org/docs/editor/',
  'http://blog.dartwatch.com/p/community-dart-packages-and-examples.html',
  'http://www.dartlang.org/slides/2012/06/io12/Bullseye-Your-first-Dart-app-Codelab-GoogleIO2012.pdf',
  'http://www.mendeley.com/',
  'http://www.google.com/+/learnmore/hangouts/?hl=en',
  'http://en.wikipedia.org/wiki/Massive_open_online_course',
  'http://www.jhsph.edu/news/news-releases/2013/spira-sleep-alzheimer.html',
  'http://www.major2nd.com/users/ghost/papers/spa2008/spa2008-text.html',
  'https://github.com/vhf/free-programming-books',
  'http://www.baliiloveyou.com/villas',
  'http://goodui.org/',
  'http://www.indiegogo.com/projects/angel-the-first-open-sensor-for-health-and-fitness',
  'https://assemblymade.com/hello',
  'https://news.ycombinator.com/item?id=6597336',
  'http://blog.pieratt.com/post/64881538909/work-versus-life-greatness-versus-family',
  'http://www.ianbicking.org/blog/2013/10/why-isnt-programming-futuristic.html',
  'https://www.dartlang.org/docs/tutorials/polymer-intro/',
  'http://blog.butlermatt.me/?p=71',
  'https://bitbucket.org/AndrewVernon/hx2dart',
  'http://blog.bettercloud.com/google-apps-stats/',
  'http://www.trendir.com/house-design/concrete-house-built-for-strong-winds.html',
  'https://www.hackerschool.com/blog/25-who-comes-to-hacker-school',
  'http://www.ctoaas.co/blog/2013/10/24/teams-shouldnt-need-to-reach-consensus/',
  'http://ideas.time.com/2013/10/22/how-to-build-willpower-for-the-weak/',
  'http://www.sitekickr.com/blog/sitting-web-developers-life-sentence/',
  'http://www.metro.us/newyork/news/2013/10/22/airbnb-a-huge-boost-to-citys-economy-study/',
  'http://www.itworld.com/cloud-computing/379566/don-t-go-programming-if-you-don-t-have-good-thesaurus',
  'http://opinionator.blogs.nytimes.com/2013/10/23/in-flipped-classrooms-a-method-for-mastery/',
  'https://news.ycombinator.com/item?id=6605193',
  'http://37signals.com/remote/',
  'http://blog.codeship.io/2013/10/24/codeship-dart-support.html',
  'http://arstechnica.com/security/2013/10/a-relatively-easy-to-understand-primer-on-elliptic-curve-cryptography/',
  'http://fr.openclassrooms.com/',
  'http://pathbrite.com/blog/design-thinking-in-the-classroom/',
  'http://www.theguardian.com/higher-education-network/blog/2013/oct/21/open-access-myths-peter-suber-harvard',
  'http://www.6yka.com/novost/45866/28-najintrigantnijih-gradova-svijeta',
  'http://www.houzz.com/photos',
  'http://miss-cranky-pants.quora.com/Tip-From-Life-Hacks',
  'http://searchlightsandsunglasses.org/',
  'http://www.htdp.org/',
  'http://whitedb.org/',
  'http://www.aosabook.org/en/index.html',
  'http://onwebradio.com/CFOX-FM-99.3-Vancouver-Canada-Live-Radio_16336.aspx',
  'http://www.rdio.com/people/MiroslavBjelokapic/',
  'http://www.stitcher.com/?refid=emlstories20131024',
  'http://www.reverbnation.com/',
  'https://github.com/sethladd/dart-polymer-dart-examples/tree/master/web/custom_element_insert_into_light_dom',
  'http://www.e-novine.com/kultura/kultura-tema/36865-Savremeno-kolovanje-podanika.html',
  'http://www.cantrip.org/gatto.html',
  'http://www.mongodb.com/blog',
  'https://www.usenix.org/system/files/1309_14-17_mickens.pdf',
  'http://froont.com/',
  'http://www.lutanho.net/play/abalone.html',
  'http://blog.intuit.ca/what-i-wish-i-knew-kerry-morrison-ceo-endloop-mobile/',
  'http://www.quora.com/Life/How-will-people-react-to-moving-from-a-low-to-a-high-standard-of-living',
  'http://narrative.ly/pieces-of-mind/nick-brown-smelled-bull/',
  'http://samizdat.mines.edu/howto/HowToBeAProgrammer.html',
  'http://sciencenordic.com/boss-not-workload-causes-workplace-depression',
  'http://tutorialzine.com/2013/10/12-awesome-css3-features-you-can-finally-use/',
  'http://benbleasdaleblogs.wordpress.com/2013/10/23/want-to-see-an-enzyme-check-inside-your-nose/',
  'http://blog.ploeh.dk/2013/10/23/mocks-for-commands-stubs-for-queries/',
  'http://www.nytimes.com/2013/10/27/opinion/sunday/bruni-italy-breaks-your-heart.html',
  'http://www.nytimes.com/2013/10/26/opinion/blow-billionaires-row-and-welfare-lines.html',
  'http://www.nybooks.com/articles/archives/2013/nov/07/climate-change-gambling-civilization/',
  'http://pcottle.github.io/learnGitBranching/',
  'http://www.slate.com/blogs/browbeat/2013/10/24/quitting_academic_jobs_professor_zachary_ernst_and_other_leaving_tenure.html',
  'https://cloudant.com/blog/pouchdb/',
  'http://www.nytimes.com/2013/10/27/opinion/sunday/slaves-of-the-internet-unite.html',
  'http://blossoms.mit.edu/videos/lessons/taking_walks_delivering_mail_introduction_graph_theory',
  'http://blogs.kqed.org/mindshift/2013/09/a-school-with-no-teachers-where-students-teach-themselves/',
  'https://www.youtube.com/watch?v=VxTamiSIVMY',
  'http://glaforge.appspot.com/article/functional-groovy-presentation',
  'http://istommydrunk.svbtle.com/mvp-is-about-not-wasting-your-life',
  'http://www.squarespace.com/stories/#hide-x-stitch',
  'https://www.strikingly.com/',
  'http://codegeneration.net/',
  'http://www.deusexmachinatio.com/blog/2013/8/4/fashion-fake-geek-girls-and-worldcon.html',
  'http://bower.io/',
  'http://blog.houseplans.com/article/define-your-architectural-program',
  'http://victorsavkin.com/post/65519559752/contrasting-backbone-and-angular',
  'https://github.com/butlermatt/dart_HTML5_Canvas',
  'http://chimera.labs.oreilly.com/books/1234000001654/index.html',
  'http://blog.butlermatt.me/?p=63',
  'http://www.designfloat.com/blog/2013/10/30/best-free-coding-education-resources/',
  'http://www.houseplans.com/plan/640-square-feet-1-bedroom-1-bathroom-0-garage-modern-38327',
  'http://sagecreekproductions.wordpress.com/',
  'http://www.codewars.com/',
  'http://weblog.bocoup.com/building-multiplayer-html5-games-with-cloak/',
  'http://getaviate.com/',
  'http://blog.alexmaccaw.com/asynchronous-ui',
  'https://www.dartlang.org/articles/event-loop/',
  'https://www.canva.com/',
  'https://coderwall.com/p/crj69a',
  'https://medium.com/understandings-epiphanies/2bed2dd4ed78',
  'http://restcountries.eu/',
  'http://blog.butlermatt.me/?p=85',
  'http://voir.ca/musique/2013/10/31/lhistoire-du-1036-quartier-general/',
  'https://lockitron.com/',
  'https://nest.com/',
  'http://needwant.com/p/buying-apartment-airbnb/',
  'http://www.businessinsider.com/google-employees-confess-the-worst-things-about-working-at-google-2013-11',
  'http://howtocode.io/',
  'http://joshsymonds.com/blog/2013/11/03/what-makes-a-good-programmer-good/',
  'http://daltoncaldwell.com/why-having-an-mba-is-a-negative-hiring-signal',
  'https://news.ycombinator.com/item?id=6663174',
  'http://blogs.scientificamerican.com/cross-check/2013/11/02/a-dig-through-old-files-reminds-me-why-im-so-critical-of-science/',
  'http://arxiv.org/abs/cs.DS/0111050',
  'http://www.theguardian.com/society/2013/nov/01/secrets-worlds-happiest-cities-commute-property-prices',
  'http://nathanleclaire.com/blog/2013/10/16/commit-every-day/',
  'http://marginalrevolution.com/marginalrevolution/2013/10/learning-to-compete-or-cooperate.html',
  'http://aralbalkan.com/notes/responsive-pixels/',
  'http://tutorialzine.com/2013/10/12-awesome-css3-features-you-can-finally-use/',
  'http://fivera.net/create-a-self-hosted-wordpress-site-for-free/',
  'http://www.nytimes.com/2013/11/03/education/edlife/finding-life-after-academia-and-not-feeling-bad-about-it.html',
  'http://blog.houseplans.com/article/understanding-design-drawings',
  'https://blogs.oracle.com/geertjan/entry/dart_and_netbeans_ide_7',
  'https://akbiggs.silvrback.com/on-game-development',
  'http://www.nomadmicrohomes.com/',
  'http://www.mymodernmet.com/profiles/blogs/ian-lorne-kent-nomad-micro-home',
  'https://webmenu.org/apps/webmenu',
  'http://influxdb.org/',
  'http://www.fastcompany.com/3021179/secrets-of-running-a-six-figure-airbnb-business',
  'http://www.drdobbs.com/architecture-and-design/2013-developer-salary-survey/240163580',
  'https://weworkremotely.com/',
  'https://www.dartlang.org/docs/dart-up-and-running/contents/ch02.html',
  'http://news.dartlang.org/2013/11/angular-announces-angulardart.html',
  'http://en.wikipedia.org/wiki/Missing_square_puzzle',
  'https://github.com/bp74/StageXL_Samples',
  'https://github.com/PBS-KIDS/Platypus',
  'http://cacm.acm.org/blogs/blog-cacm/168862-results-from-the-first-year-course-moocs-not-there-yet/fulltext',
  'http://www.houzz.com/ideabooks/18929429/list/Visit-a-California-Hillside-House-Rooted-in-Nature',
  'http://www.scotiabank.com/gillerprize/0,,5813,00.html',
  'http://www.sloanecroatia.com/blog/other-side-of-croatia/',
  'https://github.com/ErikGrimes/polymer_ui_elements',
  'http://www.zenprogrammer.org/',
  'http://blog.soat.fr/2013/11/10-trucs-infaillibles-pour-rater-ses-tests-unitaires-en-toutes-circonstances-22/',
  'http://mashable.com/2013/11/05/google-announces-helpouts/',
  'http://anewdomain.net/2013/11/05/mike-elgan/',
  'https://www.dartlang.org/docs/tutorials/connect-dart-html/',
  'http://internationalliving.com/2013/11/doctor-explains-affordable-care-act-means-expats/',
  'http://sploid.gizmodo.com/animating-famous-paintings-are-freaking-hilarious-1459175346',
  'http://geekfeminism.org/2012/09/29/quick-hit-how-git-shows-the-patriarchal-nature-of-the-software-industry/',
  'http://successfulsoftware.net/2013/11/06/lifestyle-programming/',
  'http://alexkrupp.typepad.com/sensemaking/2013/11/2012-my-year-of-code.html',
  'http://www.houseplans.com/',
  'http://fr.slideshare.net/adamnash/personal-finance-for-engineers-twitter-2013',
  'http://toxicdump.org/stuff/FourierToy.swf',
  'http://www.pathfinderinternational.net/ec-report/',
  'http://www.xcubegames.com/blog/5-major-benefits-of-html5-game-development/',
  'http://voir.ca/nouvelles/2013/11/07/nid-dcoucou-un-defi-de-taille-pour-improvisateurs-avertis/',
  'http://iznadsvih.blogspot.ca/2013/09/sarajevo-moje-voljeno_29.html',
  'http://voir.ca/chroniques/2013/11/06/ogden-cest-pas-un-cave-ou-limportance-daller-au-dela-de-la-premiere-impression/',
  'http://www.sadanduseless.com/2013/10/the-married-kama-sutra/',
  'http://updates.html5rocks.com/2013/11/The-Yeoman-Monthly-Digest-1',
  'http://work.j832.com/2013/11/if-you-do-any-open-source-development.html',
  'http://likesandpluses.com/reasons-to-not-own-a-car',
  'http://www.lisbonlux.com/magazine/25-reasons-to-love-lisbon/',
  'http://www.theoutlinerofgiants.com/',
  'http://branchez-vous.com/2013/08/20/le-vaguebooker-ce-narcissique-incompris/',
  'http://internationalliving.com/2013/01/theres-no-such-thing-as-boredom-in-boquete-panama/',
  'http://www.sharegoodthings.net/',
  'http://www.jasondavies.com/maps/rotate/',
  'http://google.github.io/quiver-dart/',
  'http://www.linkedin.com/groups/Rich-Internet-Applications-Engineer-Dart-4124554.S.5804347538836303876',
  'http://cruisesheet.com/',
  'https://news.ycombinator.com/item?id=6697416',
  'http://tynan.com/cruisework',
  'http://tynan.com/transatlantic?',
  'http://www.washingtonpost.com/blogs/worldviews/wp/2013/11/07/a-stunning-map-of-depression-rates-around-the-world/',
  'https://news.ycombinator.com/item?id=6697572',
  'http://harpers.org/wp-content/uploads/2008/09/HarpersMagazine-1996-01-0007859.pdf',
  'https://github.com/Dobiasd/articles/blob/master/switching_from_imperative_to_functional_programming_with_games_in_Elm.md',
  'https://news.ycombinator.com/item?id=6695648',
  'http://www.ndpsoftware.com/git-cheatsheet.html',
  'http://nanowrimo.org/',
  'http://bitly-cloned.herokuapp.com/',
  'http://pub.dartlang.org/packages/neuquant',
  'http://www.archdaily.com/445596/ermitage-septembre/',
  'http://tinyhouseblog.com/yourstory/beautiful-tiny-home-bethesda/',
  'http://www.buzzfeed.com/video/andrewilnyckyj/6-essential-mac-tips',
  'http://www.houseplans.com/plan/1225-square-feet-2-bedroom-2-bathroom-0-garage-southern-38296',
  'http://pretdart.com/comment-ca-marche/',
  'http://www.pyret.org/',
  'http://blog.nullspace.io/apple-2-lisp-part-1.html',
  'http://www.zolmeister.com/2013/10/the-pond.html',
  'http://www.mnot.net/cache_docs/',
  'https://medium.com/futures-exchange/3be652b8eccb',
  'http://www.stefankendall.com/2013/11/10-questions-to-ask-your-potential.html',
  'http://hackingbusinessmodel.info/',
  'http://www.ecoplandesign.com/gallery/',
  'http://johnwolfendale.wordpress.com/2009/09/01/10-of-the-worlds-best-eco-houses/',
  'http://danielhough.co.uk/blog/unhuddled/',
  'http://www.heydonworks.com/article/tetris-the-power-of-css',
  'https://news.ycombinator.com/item?id=6712703',
  'http://www.sarahmei.com/blog/2013/11/11/why-you-should-never-use-mongodb/',
  'http://tinyhouseblog.com/yurts/tiny-spiritual-retreat-cabins/',
  'http://css-tricks.com/modular-future-web-components/',
  'http://www.fastcompany.com/3018598/for-99-this-ceo-can-tell-you-what-might-kill-you-inside-23andme-founder-anne-wojcickis-dna-r',
  'http://www.ed2go.com/',
  'http://www.theguardian.com/world/2013/oct/20/marinaleda-spanish-communist-village-utopia',
  'http://sitr.us/2013/11/04/functional-data-structures.html',
  'https://github.com/vadimtsushko/angular_objectory_demo',
  'https://github.com/vsavkin/angulardart-sample-app',
  'https://speakerdeck.com/minipai/angular-dot-js-for-designers',
  'http://www.jonathanbroquist.com/building-a-google-calendar-booking-app-with-mongodb-expressjs-angularjs-and-node-js-part-1/',
  'http://www.infoq.com/presentations/io-functional-side-effects',
  'https://vividcortex.com/blog/2013/10/23/big-o-notation-made-simple/',
  'http://www.toptal.com/angular-js/a-step-by-step-guide-to-your-first-angularjs-app',
  'http://maryrosecook.com/blog/post/a-practical-introduction-to-functional-programming',
  'http://arxiv.org/abs/cs.DS/0111050',
  'https://github.com/airbnb/javascript',
  'http://acsmooc.blogspot.ca/2013/11/on-technical-vs-qualitative-courses_12.html',
  'http://plpnetwork.com/2013/11/07/obsession-academic-teaching-preparing-kids-life/',
  'http://www.trendir.com/house-design/ultramodern-reinvention-of-traditional-woodland-cabin-with-timber-structure.html',
];

var emailList = [
  'stephanie@martinez.com',
  'antonio@flores.com',
  'brian@lewis.com',
  'christine@chen.com',
  'anna@ruiz.com',
  'matthew@martinez.com',
  'chris@rodriguez.com',
  'brian@white.com',
  'martin@stewart.com',
  'jessica@tan.com',
  'jason@kelly.com',
  'brian@sharma.com',
  'sharon@silva.com',
  'tom@walker.com',
  'michelle@taylor.com',
  'rachel@wilson.com',
  'claudia@mitchell.com',
  'andrea@ramirez.com',
  'michael@clark.com',
  'richard@jones.com',
  'susan@mitchell.com',
  'lisa@morales.com',
  'debbie@hughes.com',
  'jennifer@collins.com',
  'peter@tan.com',
  'patricia@rodriguez.com',
  'heather@morris.com',
  'tony@king.com',
  'eric@nelson.com',
  'julie@gonzalez.com',
  'jonathan@ruiz.com',
  'susan@hill.com',
  'eric@hall.com',
  'sandra@mohamed.com',
  'sam@adams.com',
  'heather@williams.com',
  'julie@li.com',
  'andrea@wong.com',
  'david@macdonald.com',
  'ashley@cruz.com',
  'tony@ramirez.com',
  'james@rossi.com',
  'stephen@torres.com',
  'jack@gomez.com',
  'daniel@hughes.com',
  'rachel@stewart.com',
  'laura@shah.com',
  'brian@gomez.com',
  'maria@li.com',
  'sharon@garcia.com',
  'sharon@wang.com',
  'mike@fernandez.com',
  'anne@moore.com',
  'jennifer@perez.com',
  'kim@hernandez.com',
  'julie@martin.com',
  'matt@wang.com',
  'stephanie@jones.com',
  'marie@thomas.com',
  'jim@king.com',
  'tom@robinson.com',
  'kim@morris.com',
  'marie@roberts.com',
  'andrea@macdonald.com',
  'james@edwards.com',
  'joe@ali.com',
  'elizabeth@nguyen.com',
  'antonio@gutierrez.com',
  'jeff@james.com',
  'angela@adams.com',
  'daniel@bell.com',
  'thomas@ahmed.com',
  'steven@hernandez.com',
  'amanda@ramirez.com',
  'andy@chan.com',
  'lisa@reyes.com',
  'martin@jones.com',
  'luis@ali.com',
  'susan@wright.com',
  'matthew@hall.com',
  'barbara@ali.com',
  'rachel@turner.com',
  'anne@macdonald.com',
  'jennifer@morales.com',
  'mary@garcia.com',
  'karen@harris.com',
  'michelle@ruiz.com',
  'chris@morgan.com',
  'dan@clark.com',
  'julie@ramirez.com',
  'michael@nguyen.com',
  'karen@adams.com',
  'anna@king.com',
  'amy@morris.com',
  'andrew@hughes.com',
  'mohamed@walker.com',
  'steven@kumar.com',
  'luis@collins.com',
  'dave@flores.com',
  'angela@harris.com',
  'claudia@morales.com',
  'dan@sanchez.com',
  'nancy@scott.com',
  'richard@demir.com',
  'rachel@young.com',
  'kelly@harris.com',
  'matthew@sharma.com',
  'scott@sharma.com',
  'patricia@turner.com',
  'kevin@torres.com',
  'linda@rivera.com',
  'steven@cooper.com',
  'john@murphy.com',
  'tim@ng.com',
  'ashley@li.com',
  'nicole@hall.com',
  'jean@gomez.com',
  'chris@patel.com',
  'kevin@adams.com',
  'antonio@shah.com',
  'jessica@bell.com',
  'melissa@flores.com',
  'carlos@jackson.com',
  'dave@ruiz.com',
  'jack@hernandez.com',
  'matt@nguyen.com',
  'scott@bell.com',
  'sandra@jackson.com',
  'jonathan@parker.com',
  'barbara@campbell.com',
  'sarah@shah.com',
  'susan@patel.com',
  'debbie@rossi.com',
  'matthew@sanchez.com',
  'sandra@li.com',
  'daniel@murphy.com',
  'linda@nguyen.com',
  'mary@young.com',
  'andrea@thomas.com',
  'susan@kelly.com',
  'jack@hansen.com',
  'sarah@ahmed.com',
  'gary@walker.com',
  'kelly@khan.com',
  'anna@carter.com',
  'angela@green.com',
  'andrea@lim.com',
  'melissa@patel.com',
  'christian@anderson.com',
  'julie@king.com',
  'michelle@wilson.com',
  'marco@khan.com',
  'elizabeth@chen.com',
  'thomas@nguyen.com',
  'jack@gonzalez.com',
  'barbara@lim.com',
  'steve@chan.com',
  'barbara@carter.com',
  'marie@tan.com',
  'adam@harris.com',
  'luis@morales.com',
  'stephen@walker.com',
  'debbie@davies.com',
  'richard@cruz.com',
  'lisa@garcia.com',
  'linda@lopez.com',
  'debbie@mitchell.com',
  'jeff@chan.com',
  'cindy@sharma.com',
  'jim@lim.com',
  'sam@morgan.com',
  'matt@lee.com',
  'robert@thomas.com',
  'sam@white.com',
  'mike@garcia.com',
  'jonathan@allen.com',
  'jonathan@kim.com',
  'stephanie@singh.com',
  'andy@murphy.com',
  'susan@edwards.com',
  'marie@kim.com',
  'barbara@wong.com',
  'monica@hernandez.com',
  'steven@allen.com',
  'maria@miller.com',
  'sara@clark.com',
  'martin@robinson.com',
  'sandra@morales.com',
  'patrick@walker.com',
  'alex@miller.com',
  'susan@adams.com',
  'adam@green.com',
  'anna@ramirez.com',
  'tim@lee.com',
  'christine@hernandez.com',
  'sam@collins.com',
  'john@ahmed.com',
  'tony@ahmed.com',
  'laura@thomas.com',
  'mark@ruiz.com',
  'michelle@king.com',
  'martin@baker.com',
  'jennifer@davies.com',
  'andrew@james.com',
  'cindy@macdonald.com',
  'michael@lim.com',
  'luis@martin.com',
  'peter@johnson.com',
  'richard@miller.com',
  'susan@collins.com',
  'elizabeth@mohamed.com',
  'claudia@wilson.com',
  'william@jackson.com',
  'elizabeth@singh.com',
  'rachel@hill.com',
  'claudia@can.com',
  'rachel@lewis.com',
  'michael@mitchell.com',
  'laura@can.com',
  'stephanie@perez.com',
  'jose@phillips.com',
  'sam@hall.com',
  'andrew@nguyen.com',
  'marie@chen.com',
  'jessica@lee.com',
  'nick@smith.com',
  'jeff@davies.com',
  'amy@bell.com',
  'mohamed@wong.com',
  'cindy@perez.com',
  'rachel@jones.com',
  'kelly@demir.com',
  'dan@mohamed.com',
  'alex@can.com',
  'susan@morris.com',
  'joe@kumar.com',
  'george@thompson.com',
  'alex@gutierrez.com',
  'michelle@bell.com',
  'monica@davis.com',
  'ryan@collins.com',
  'steven@wong.com',
  'john@jones.com',
  'ahmed@taylor.com',
  'patricia@walker.com',
  'patricia@roberts.com',
  'paul@fernandez.com',
  'chris@wang.com',
  'anna@white.com',
  'eric@alvarez.com',
  'jack@sharma.com',
  'richard@diaz.com',
  'matt@torres.com',
  'stephen@wong.com',
  'andrea@davis.com',
  'adam@nelson.com',
  'carol@patel.com',
  'patricia@moore.com',
  'andrea@miller.com',
  'marco@ahmed.com',
  'steven@gonzalez.com',
  'marco@li.com',
  'mark@turner.com',
  'john@flores.com',
  'anthony@alvarez.com',
  'marie@parker.com',
  'steve@roberts.com',
  'jeff@jackson.com',
  'melissa@jackson.com',
  'richard@johnson.com',
  'matt@davis.com',
  'tom@macdonald.com',
  'ashley@shah.com',
  'patricia@martin.com',
  'kevin@torres.com',
  'peter@ahmed.com',
  'steve@kumar.com',
  'patrick@hansen.com',
  'mike@lee.com',
  'chris@lim.com',
  'dan@gonzalez.com',
  'nicole@roberts.com',
  'matthew@tan.com',
  'ashley@kelly.com',
  'carol@reyes.com',
  'michelle@cruz.com',
  'dan@morris.com',
  'eric@scott.com',
  'jennifer@lewis.com',
  'michelle@parker.com',
  'andrew@evans.com',
  'mike@rodriguez.com',
  'robert@ng.com',
  'amanda@baker.com',
  'brian@james.com',
  'dave@gutierrez.com',
  'amanda@jackson.com',
  'dave@garcia.com',
  'cindy@turner.com',
  'amanda@anderson.com',
  'marie@evans.com',
  'bob@baker.com',
  'chris@diaz.com',
  'elizabeth@edwards.com',
  'william@kelly.com',
  'juan@stewart.com',
  'carol@singh.com',
  'alex@kumar.com',
  'mary@hansen.com',
  'matthew@morales.com',
  'thomas@white.com',
  'claudia@kim.com',
  'andy@thompson.com',
  'jeff@james.com',
  'mike@khan.com',
  'nicole@white.com',
  'alex@ahmed.com',
  'stephanie@hill.com',
  'robert@davies.com',
  'carol@robinson.com',
  'amanda@sharma.com',
  'antonio@thompson.com',
  'andrew@can.com',
  'adam@lim.com',
  'heather@anderson.com',
  'ahmed@walker.com',
  'debbie@shah.com',
  'marco@kelly.com',
  'ashley@nelson.com',
  'christian@king.com',
  'sandra@ahmed.com',
  'marco@hansen.com',
  'michael@kumar.com',
  'steve@james.com',
  'karen@wong.com',
  'bob@hernandez.com',
  'michelle@cruz.com',
  'adam@hill.com',
  'maria@chan.com',
  'dave@lopez.com',
  'scott@parker.com',
  'jose@silva.com',
  'ben@gutierrez.com',
  'monica@mitchell.com',
  'steve@davis.com',
  'amy@ahmed.com',
  'michelle@chen.com',
  'daniel@lee.com',
  'anthony@lopez.com',
  'jonathan@wang.com',
  'juan@evans.com',
  'sarah@nelson.com',
  'andrea@rossi.com',
  'nicole@ahmed.com',
  'robert@king.com',
  'sarah@lee.com',
  'matthew@clark.com',
  'andrea@ng.com',
  'john@shah.com',
  'peter@perez.com',
  'monica@gutierrez.com',
  'mohamed@li.com',
  'marco@shah.com',
  'sara@james.com',
  'amy@chan.com',
  'nick@ruiz.com',
  'michael@young.com',
  'patrick@smith.com',
  'kelly@young.com',
  'ahmed@robinson.com',
  'james@reyes.com',
  'susan@wong.com',
  'dan@perez.com',
  'patrick@thompson.com',
  'maria@morgan.com',
  'gary@kelly.com',
  'bill@hernandez.com',
  'susan@perez.com',
  'kim@kelly.com',
  'matthew@jones.com',
  'steve@adams.com',
  'andy@campbell.com',
  'steve@james.com',
  'sharon@ramirez.com',
  'jennifer@wood.com',
  'ben@lopez.com',
  'luis@miller.com',
  'sara@jackson.com',
  'jonathan@silva.com',
  'ahmed@nelson.com',
  'christine@campbell.com',
  'maria@clark.com',
  'ali@silva.com',
  'andrea@jones.com',
  'elizabeth@green.com',
  'mohamed@moore.com',
  'adam@james.com',
  'monica@gutierrez.com',
  'jonathan@parker.com',
  'jose@ahmed.com',
  'steve@harris.com',
  'michelle@sharma.com',
  'monica@green.com',
  'michael@hughes.com',
  'nicole@miller.com',
  'debbie@jackson.com',
  'marie@campbell.com',
  'juan@bell.com',
  'bob@hall.com',
  'rachel@davis.com',
  'chris@wood.com',
  'steve@carter.com',
  'julie@hughes.com',
  'rachel@brown.com',
  'carlos@young.com',
  'michael@edwards.com',
  'ahmed@singh.com',
  'laura@khan.com',
  'robert@patel.com',
  'adam@hall.com',
  'claudia@chen.com',
  'scott@gonzalez.com',
  'daniel@sanchez.com',
  'ali@diaz.com',
  'mark@bell.com',
  'karen@roberts.com',
  'debbie@nelson.com',
  'nancy@gutierrez.com',
  'andrew@miller.com',
  'sam@green.com',
  'scott@scott.com',
  'sarah@hernandez.com',
  'john@diaz.com',
  'maria@james.com',
  'sharon@harris.com',
  'matthew@evans.com',
  'joe@ali.com',
  'tom@davies.com',
  'nick@martin.com',
  'ali@morales.com',
  'marco@silva.com',
  'sandra@king.com',
  'sandra@jackson.com',
  'jim@wright.com',
  'jessica@gutierrez.com',
  'tom@evans.com',
  'sarah@davis.com',
  'daniel@kelly.com',
  'mary@perez.com',
  'heather@alvarez.com',
  'jack@hall.com',
  'steven@kelly.com',
  'jason@reyes.com',
  'ahmed@flores.com',
  'jonathan@smith.com',
  'carol@phillips.com',
  'anna@bell.com',
  'mark@williams.com',
  'angela@murphy.com',
  'matthew@davies.com',
  'jeff@hill.com',
  'matt@scott.com',
  'jack@johnson.com',
  'andrea@lopez.com',
  'christian@thomas.com',
  'juan@edwards.com',
  'ben@wang.com',
  'david@hernandez.com',
  'richard@tan.com',
  'george@patel.com',
  'heather@evans.com',
  'carlos@hansen.com',
  'michael@lewis.com',
  'matt@anderson.com',
  'george@baker.com',
  'michelle@martin.com',
  'peter@can.com',
  'julie@walker.com',
  'debbie@johnson.com',
  'michelle@lopez.com',
  'jonathan@morris.com',
  'sarah@young.com',
  'alex@lewis.com',
  'joe@diaz.com',
  'ali@edwards.com',
  'julie@thompson.com',
  'barbara@thomas.com',
  'jeff@singh.com',
  'sam@alvarez.com',
  'peter@lim.com',
  'carlos@turner.com',
  'tony@white.com',
  'luis@scott.com',
  'sandra@hernandez.com',
  'mohamed@tan.com',
  'sara@williams.com',
  'daniel@nguyen.com',
  'christian@mitchell.com',
  'matt@lopez.com',
  'angela@clark.com',
  'alex@nguyen.com',
  'amanda@jackson.com',
  'juan@wright.com',
  'debbie@alvarez.com',
  'ashley@morris.com',
  'nancy@edwards.com',
  'william@jones.com',
  'bill@anderson.com',
  'george@tan.com',
  'dave@ali.com',
  'michelle@johnson.com',
  'bob@thomas.com',
  'patrick@young.com',
  'bob@allen.com',
  'anna@allen.com',
  'steven@smith.com',
  'melissa@silva.com',
  'ashley@white.com',
  'laura@ruiz.com',
  'antonio@morales.com',
  'george@murphy.com',
  'jessica@murphy.com',
  'barbara@anderson.com',
  'marco@clark.com',
  'dave@morgan.com',
  'bill@kim.com',
  'joe@patel.com',
  'william@patel.com',
  'nick@gomez.com',
  'tim@rivera.com',
  'julie@hall.com',
  'adam@khan.com',
  'patrick@gutierrez.com',
  'antonio@brown.com',
  'christian@martin.com',
  'anna@robinson.com',
  'robert@lim.com',
  'amy@lopez.com',
  'amy@sharma.com',
  'andy@roberts.com',
  'william@jones.com',
  'scott@li.com',
  'rachel@can.com',
  'sam@sharma.com',
  'sarah@bell.com',
  'steve@baker.com',
  'patricia@chen.com',
  'andrea@khan.com',
  'jean@li.com',
  'melissa@gomez.com',
  'jonathan@baker.com',
  'daniel@nguyen.com',
  'ashley@baker.com',
  'martin@murphy.com',
  'cindy@harris.com',
  'adam@ramirez.com',
  'maria@demir.com',
  'amy@anderson.com',
  'luis@davis.com',
  'elizabeth@ramirez.com',
  'andy@morgan.com',
  'amy@adams.com',
  'stephen@lewis.com',
  'marco@ramirez.com',
  'ryan@baker.com',
  'luis@shah.com',
  'kim@sanchez.com',
  'matt@roberts.com',
  'christian@gutierrez.com',
  'angela@edwards.com',
  'dan@morales.com',
  'heather@nguyen.com',
  'daniel@jackson.com',
  'marco@martin.com',
  'jason@turner.com',
  'george@adams.com',
  'jessica@diaz.com',
  'joe@thomas.com',
  'matt@phillips.com',
  'linda@taylor.com',
  'karen@kelly.com',
  'dave@chan.com',
  'chris@ruiz.com',
  'patrick@murphy.com',
  'kevin@kumar.com',
  'christine@reyes.com',
  'james@allen.com',
  'jessica@king.com',
  'martin@mohamed.com',
  'marco@ramirez.com',
  'dave@walker.com',
  'matthew@demir.com',
  'michael@harris.com',
  'heather@carter.com',
  'mike@lim.com',
  'tony@sanchez.com',
  'karen@wang.com',
  'monica@lopez.com',
  'lisa@rossi.com',
  'james@torres.com',
  'tom@james.com',
  'william@patel.com',
  'brian@rodriguez.com',
  'jessica@king.com',
  'mohamed@cruz.com',
  'lisa@lopez.com',
  'kevin@perez.com',
  'christine@smith.com',
  'patrick@fernandez.com',
  'andrew@rossi.com',
  'jose@brown.com',
  'mary@mohamed.com',
  'jennifer@davies.com',
  'maria@campbell.com',
  'brian@adams.com',
  'anna@macdonald.com',
  'bill@jackson.com',
  'adam@wood.com',
  'laura@clark.com',
  'jose@martinez.com',
  'jonathan@chen.com',
  'ashley@morales.com',
  'patricia@scott.com',
  'marie@ahmed.com',
  'eric@fernandez.com',
  'carol@james.com',
  'amy@macdonald.com',
  'barbara@collins.com',
  'david@alvarez.com',
  'jessica@morris.com',
  'dave@baker.com',
  'maria@phillips.com',
  'jessica@baker.com',
  'monica@lim.com',
  'anthony@kaya.com',
  'marco@lim.com',
  'james@wood.com',
  'sam@perez.com',
  'michael@thomas.com',
  'sara@wilson.com',
  'patrick@flores.com',
  'gary@nelson.com',
  'daniel@robinson.com',
  'james@fernandez.com',
  'peter@smith.com',
  'bill@mitchell.com',
  'elizabeth@allen.com',
  'nancy@sanchez.com',
  'stephanie@wang.com',
  'sandra@can.com',
  'william@king.com',
  'anne@carter.com',
  'stephen@baker.com',
  'stephen@alvarez.com',
  'anne@ahmed.com',
  'ryan@carter.com',
  'dave@wong.com',
  'debbie@wang.com',
  'kim@cruz.com',
  'joe@flores.com',
  'steven@wilson.com',
  'carlos@ahmed.com',
  'ryan@reyes.com',
  'michelle@fernandez.com',
  'brian@torres.com',
  'adam@rossi.com',
  'patricia@li.com',
  'chris@hansen.com',
  'stephanie@diaz.com',
  'julie@ramirez.com',
  'john@brown.com',
  'gary@mohamed.com',
  'bill@king.com',
  'bill@martin.com',
  'daniel@hall.com',
  'ryan@gomez.com',
  'mohamed@cruz.com',
  'heather@fernandez.com',
  'nick@rossi.com',
  'matt@gomez.com',
  'sarah@jones.com',
  'luis@adams.com',
  'eric@singh.com',
  'julie@wood.com',
  'robert@nelson.com',
  'sarah@lim.com',
  'carol@hill.com',
  'amy@kaya.com',
  'daniel@murphy.com',
  'jonathan@ng.com',
  'david@sanchez.com',
  'bob@nguyen.com',
  'richard@cruz.com',
  'patricia@gutierrez.com',
  'bob@lee.com',
  'tom@gonzalez.com',
  'heather@ahmed.com',
  'michelle@taylor.com',
  'heather@gonzalez.com',
  'elizabeth@hughes.com',
  'jack@parker.com',
  'maria@young.com',
  'amy@edwards.com',
  'jessica@ali.com',
  'jack@hughes.com',
  'brian@james.com',
  'jack@walker.com',
  'thomas@lopez.com',
  'sara@rodriguez.com',
  'kim@turner.com',
  'amy@can.com',
  'bob@wood.com',
  'anna@gomez.com',
  'jason@lopez.com',
  'jim@martinez.com',
  'patrick@jackson.com',
  'lisa@rossi.com',
  'linda@taylor.com',
  'matthew@ruiz.com',
  'jonathan@mitchell.com',
  'nick@chan.com',
  'tom@walker.com',
  'jim@rodriguez.com',
  'jean@fernandez.com',
  'sharon@can.com',
  'patricia@williams.com',
  'martin@murphy.com',
  'claudia@lim.com',
  'brian@turner.com',
  'thomas@patel.com',
  'steven@rivera.com',
  'george@johnson.com',
  'peter@kim.com',
  'joe@edwards.com',
  'tom@lopez.com',
  'james@thompson.com',
  'cindy@young.com',
  'julie@kumar.com',
  'laura@kumar.com',
  'gary@hansen.com',
  'elizabeth@hall.com',
  'amanda@reyes.com',
  'michelle@wright.com',
  'jonathan@lopez.com',
  'stephen@ruiz.com',
  'paul@thomas.com',
  'jennifer@chan.com',
  'jim@fernandez.com',
  'gary@cruz.com',
  'matt@kim.com',
  'nancy@sanchez.com',
  'matt@carter.com',
  'william@rossi.com',
  'christine@sanchez.com',
  'amy@robinson.com',
  'anna@clark.com',
  'jim@chan.com',
  'jim@wong.com',
  'sandra@patel.com',
  'carol@diaz.com',
  'paul@williams.com',
  'sandra@wright.com',
  'marco@white.com',
  'bob@carter.com',
  'eric@perez.com',
  'lisa@flores.com',
  'david@king.com',
  'mary@kumar.com',
  'sara@gutierrez.com',
  'bill@lopez.com',
  'jim@morris.com',
  'james@macdonald.com',
  'bill@wilson.com',
  'monica@can.com',
  'matt@davies.com',
  'luis@cooper.com',
  'kevin@lopez.com',
  'scott@adams.com',
  'rachel@young.com',
  'sharon@cruz.com',
  'thomas@morales.com',
  'sarah@tan.com',
  'peter@khan.com',
  'eric@stewart.com',
  'ryan@mitchell.com',
  'michelle@jones.com',
  'andrea@lim.com',
  'matthew@lim.com',
  'andy@ng.com',
  'laura@roberts.com',
  'tom@gutierrez.com',
  'mike@anderson.com',
  'melissa@davies.com',
  'marco@can.com',
  'william@nguyen.com',
  'alex@evans.com',
  'luis@kumar.com',
  'john@morales.com',
  'jean@martin.com',
  'juan@martinez.com',
  'debbie@lewis.com',
  'jack@wright.com',
  'elizabeth@collins.com',
  'kelly@chen.com',
  'ben@rodriguez.com',
  'ryan@jackson.com',
  'thomas@young.com',
  'ben@torres.com',
  'carol@anderson.com',
  'cindy@nguyen.com',
  'nancy@phillips.com',
  'andrew@gonzalez.com',
  'maria@allen.com',
  'ashley@hall.com',
  'jean@tan.com',
  'amanda@hall.com',
  'matt@wilson.com',
  'debbie@kelly.com',
  'bob@gutierrez.com',
  'stephanie@adams.com',
  'jean@jones.com',
  'mary@walker.com',
  'martin@moore.com',
  'patricia@green.com',
  'nick@parker.com',
  'ali@rivera.com',
  'ryan@tan.com',
  'jason@evans.com',
  'lisa@walker.com',
  'kevin@walker.com',
  'mike@young.com',
  'bill@harris.com',
  'adam@shah.com',
  'amy@collins.com',
  'dave@campbell.com',
  'patricia@hernandez.com',
  'michelle@evans.com',
  'gary@davis.com',
  'stephen@kim.com',
  'mary@chen.com',
  'jonathan@walker.com',
  'kim@davis.com',
  'christian@kelly.com',
  'debbie@kim.com',
  'linda@stewart.com',
  'heather@torres.com',
  'bob@ramirez.com',
  'tom@li.com',
  'elizabeth@harris.com',
  'jim@king.com',
  'bob@harris.com',
  'anne@ng.com',
  'ali@rivera.com',
  'marco@campbell.com',
  'robert@ahmed.com',
  'christian@chen.com',
  'susan@wong.com',
  'ben@gomez.com',
  'andy@clark.com',
  'jim@adams.com',
  'susan@miller.com',
  'martin@ruiz.com',
  'sandra@jackson.com',
  'patrick@mitchell.com',
  'christian@johnson.com',
  'kim@rodriguez.com',
  'brian@gonzalez.com',
  'scott@sanchez.com',
  'debbie@wong.com',
  'debbie@macdonald.com',
  'dave@cruz.com',
  'eric@young.com',
  'marco@fernandez.com',
  'anthony@morales.com',
  'amanda@ng.com',
  'bob@sharma.com',
  'elizabeth@chan.com',
  'andrea@parker.com',
  'joe@phillips.com',
  'jessica@martin.com',
  'tom@torres.com',
  'jeff@hernandez.com',
  'dave@ahmed.com',
  'mark@miller.com',
  'jason@ng.com',
  'debbie@mitchell.com',
  'kim@wang.com',
  'thomas@wood.com',
  'matthew@phillips.com',
  'mary@ahmed.com',
  'christine@moore.com',
  'david@macdonald.com',
  'laura@davis.com',
  'mohamed@lopez.com',
  'carol@clark.com',
  'brian@walker.com',
  'bob@gutierrez.com',
  'jim@lopez.com',
  'daniel@miller.com',
  'matthew@rossi.com',
  'ryan@wood.com',
  'jean@martin.com',
  'christine@nelson.com',
  'scott@moore.com',
  'steven@hansen.com',
  'john@james.com',
  'julie@lopez.com',
  'andrea@kaya.com',
  'peter@johnson.com',
  'jim@carter.com',
  'rachel@clark.com',
  'mohamed@parker.com',
  'dan@mohamed.com',
  'carlos@white.com',
  'christine@hughes.com',
  'bill@jackson.com',
  'julie@sharma.com',
  'nicole@tan.com',
  'jose@hernandez.com',
  'matt@hill.com',
  'richard@green.com',
  'david@ali.com',
  'karen@khan.com',
  'nancy@phillips.com',
  'julie@perez.com',
  'sarah@sanchez.com',
  'anna@miller.com',
  'jonathan@scott.com',
  'ahmed@stewart.com',
  'jason@lee.com',
  'tom@lee.com',
  'ali@king.com',
  'dan@green.com',
  'gary@singh.com',
  'rachel@li.com',
  'richard@davis.com',
  'tim@jones.com',
  'heather@mohamed.com',
  'anna@sharma.com',
  'ahmed@ramirez.com',
  'heather@davies.com',
  'alex@campbell.com',
  'dan@thompson.com',
  'andrea@gomez.com',
  'michelle@taylor.com',
  'jeff@gomez.com',
  'jim@lewis.com',
  'martin@chan.com',
  'alex@hughes.com',
  'kelly@reyes.com',
  'sarah@martin.com',
  'amanda@phillips.com',
  'gary@young.com',
  'matt@cooper.com',
  'anthony@kumar.com',
  'antonio@phillips.com',
  'juan@wood.com',
  'martin@thompson.com',
  'dan@walker.com',
  'sara@hughes.com',
  'nicole@wilson.com',
  'amanda@garcia.com',
  'kelly@jones.com',
  'peter@mitchell.com',
  'joe@johnson.com',
  'alex@harris.com',
  'andrew@james.com',
  'jack@thomas.com',
  'anthony@khan.com',
  'barbara@davies.com',
  'chris@mohamed.com',
  'david@rivera.com',
  'mark@anderson.com',
  'melissa@wilson.com',
  'brian@lee.com',
  'dave@rivera.com',
  'gary@cooper.com',
  'steve@chan.com',
  'jeff@wilson.com',
  'robert@roberts.com',
  'susan@ahmed.com',
  'jose@diaz.com',
  'martin@martinez.com',
  'paul@morris.com',
  'john@miller.com',
  'steven@fernandez.com',
  'jeff@macdonald.com',
  'ali@diaz.com',
  'steven@lee.com',
  'jonathan@davies.com',
  'matthew@morales.com',
  'laura@stewart.com',
  'tim@chan.com',
  'patricia@kaya.com',
  'nick@rodriguez.com',
  'kim@collins.com',
  'ben@fernandez.com',
  'dan@hernandez.com',
  'jean@williams.com',
];

class Quote {
  final String text;
  final String author;
  
  const Quote({
    required this.text,
    required this.author,
  });
}

final quotes = [
  Quote(
    text: 'You must have chaos within you to give birth to a dancing star.',
    author: 'Friedrich Nietzsche'
  ),
  Quote(
    text: 'The only way to do great work is to love what you do.',
    author: 'Steve Jobs'
  ),
  Quote(
    text: 'The best way to predict the future is to invent it.',
    author: 'Alan Kay'
  ),
  // Project completion quotes
  Quote(
    text: 'Have no fear of perfection — you\'ll never reach it.',
    author: 'Salvador Dali'
  ),
  Quote(
    text: 'Perfect is the enemy of done.',
    author: 'Catherine Carrigan'
  ),
  Quote(
    text: 'The ultimate inspiration is the deadline.',
    author: 'Nolan Bushnell'
  ),
  Quote(
    text: 'Do not seek praise, seek criticism.',
    author: 'Paul Arden'
  ),
  Quote(
    text: 'Make it simple, but significant.',
    author: 'Don Draper'
  ),
  Quote(
    text: 'Success is stumbling from failure to failure with no loss of enthusiasm.',
    author: 'Winston Churchill'
  ),
  Quote(
    text: 'The best way out is always through.',
    author: 'Robert Frost'
  ),
  Quote(
    text: 'Creativity takes courage.',
    author: 'Henri Matisse'
  ),
  Quote(
    text: 'Creativity is a habit, and the best creativity is the result of good work habits.',
    author: 'Twyla Tharp'
  ),
  Quote(
    text: 'Everything you ever wanted is on the other side of fear.',
    author: 'George Addair'
  ),
  Quote(
    text: 'Creativity requires the courage to let go of certainties.',
    author: 'Erich Fromm'
  ),
  Quote(
    text: 'You can\'t wait for inspiration, you have to go after it with a club.',
    author: 'Jack London'
  ),
  Quote(
    text: 'The three great essentials to achieve anything worthwhile are, first, hard work; second, stick-to-itiveness; third, common sense.',
    author: 'Thomas A. Edison'
  ),
  Quote(
    text: 'Many of life\'s failures are people who did not realize how close they were to success when they gave up.',
    author: 'Thomas Edison'
  ),
  Quote(
    text: 'Perseverance is failing 19 times and succeeding the 20th.',
    author: 'Julie Andrews'
  ),
  Quote(
    text: 'Energy and persistence conquer all things.',
    author: 'Benjamin Franklin'
  ),
  Quote(
    text: 'I find that the harder I work, the more luck I seem to have.',
    author: 'Thomas Jefferson'
  ),
  Quote(
    text: 'I would rather die of passion than of boredom.',
    author: 'Vincent van Gogh'
  ),
  Quote(
    text: 'Whenever you find yourself doubting how far you can go, just remember how far you have come.',
    author: 'Unknown'
  ),
  Quote(
    text: 'Don\'t let the fear of the time it will take to accomplish something stand in the way of your doing it.',
    author: 'Earl Nightingale'
  ),
  Quote(
    text: 'Creativity is always a leap of faith. You\'re faced with a blank page, blank easel, or an empty stage.',
    author: 'Julia Cameron'
  ),
  Quote(
    text: 'I live a creative life, and you can\'t be creative without being vulnerable.',
    author: 'Elizabeth Gilbert'
  ),
  Quote(
    text: 'Courage is the most important of all the virtues because without courage, you can\'t practice any other virtue consistently.',
    author: 'Maya Angelou'
  ),
  Quote(
    text: 'Done is better than perfect.',
    author: 'Sheryl Sandberg'
  ),
  Quote(
    text: 'The first rule of management is delegation. Don\'t try and do everything yourself because you can\'t.',
    author: 'Anthea Turner'
  ),
  Quote(
    text: 'To do two things at once is to do neither.',
    author: 'Publilius Syrus'
  ),
  Quote(
    text: 'Trying to manage a project without project management is like trying to play a football game without a game plan.',
    author: 'Karen Tate'
  ),
  Quote(
    text: 'The smaller the function, the greater the management.',
    author: 'C. Northcote Parkinson'
  ),
  Quote(
    text: 'Be ready to revise any system, scrap any method, abandon any theory, if the success of the job requires it.',
    author: 'Henry Ford'
  ),
  Quote(
    text: 'One of the true tests of leadership is the ability to recognize a problem before it becomes an emergency.',
    author: 'Arnold Glasow'
  ),
  Quote(
    text: 'A goal without a timeline is just a dream.',
    author: 'Robert Herjavec'
  ),
  Quote(
    text: 'A goal without a plan is just a wish.',
    author: 'Antoine de Saint-Exupéry'
  ),
  Quote(
    text: 'There are no unrealistic goals, only unrealistic deadlines.',
    author: 'Brian Tracy'
  ),
  Quote(
    text: 'The P in PM is as much about \'people management\' as it is about \'project management\'.',
    author: 'Cornelius Fichtner'
  ),
  Quote(
    text: 'Operations keeps the lights on, strategy provides a light at the end of the tunnel, but project management is the train engine that moves the organization forward.',
    author: 'Joy Gumz'
  ),
  Quote(
    text: 'The goal you set must be challenging. At the same time, it should be realistic and attainable, not impossible to reach.',
    author: 'Rick Hansen'
  ),
  Quote(
    text: 'Ten years from now, make sure you can say that you chose your life, you didn\'t settle for it.',
    author: 'Unknown'
  ),
];

const citati = [
  Quote(
    text: 'Kad bi Bog kažnjavao za svako učinjeno zlo, ne bi na zemlji ostalo ni jedno živo biće.',
    author: 'Meša Selimović'
  ),
  Quote(
    text: 'Bolje je biti častan čovek nego ministar države.',
    author: 'Milovan Đilas'
  ),
  Quote(
    text: 'Jednom davno postojao je svet u kojem smo različite jezike zvali "našima".',
    author: 'Semezdin Mehmedinović'
  ),
  Quote(
    text: 'Ja sam borac. Jer život je borba, a ne predaja.',
    author: 'Ivo Andrić'
  ),
  Quote(
    text: 'Strah je najgori čovekov neprijatelj.',
    author: 'Dobrica Ćosić'
  ),
  Quote(
    text: 'Nije čovek ono što misli, nego ono što čini.',
    author: 'Meša Selimović'
  ),
  Quote(
    text: 'Čovek je kao reka, ide kuda može, a ne kuda hoće.',
    author: 'Meša Selimović'
  ),
  Quote(
    text: 'Ljubav je jača i od smrti i od straha od smrti.',
    author: 'Ivo Andrić'
  ),
  Quote(
    text: 'Narod koji ima kulturu ne treba se plašiti za svoju budućnost.',
    author: 'Miroslav Krleža'
  ),
  Quote(
    text: 'Jedan jezik je dovoljan životu, a dva jezika su dovoljna svetu.',
    author: 'Danilo Kiš'
  ),
  Quote(
    text: 'Reči su nekada teže od najtežeg oružja.',
    author: 'Branko Ćopić'
  ),
  Quote(
    text: 'Ljudi koji ne vole ni sebe ni druge uvek imaju najviše moralnih pridika.',
    author: 'Mesa Selimović'
  ),
  Quote(
    text: 'Život je neprekidno čuđenje. Ko to ne zna, taj je mrtav.',
    author: 'Miloš Crnjanski'
  ),
  Quote(
    text: 'Jedna ista istina se različito prima u različita vremena.',
    author: 'Dobrica Ćosić'
  ),
  Quote(
    text: 'Vreme je najbolji sudija.',
    author: 'Ivo Andrić'
  ),
  Quote(
    text: 'Lako je biti star, teško je biti mudar.',
    author: 'Desanka Maksimović'
  ),
  Quote(
    text: 'Ima ljudi čija je sudbina da budu poraženi.',
    author: 'Mesa Selimović'
  ),
  Quote(
    text: 'Jedino knjige ne poznaju smrt.',
    author: 'Dobrica Ćosić'
  ),
  Quote(
    text: 'Domovina se brani lepotom.',
    author: 'Miroslav Antić'
  ),
  Quote(
    text: 'Ko pronađe dobro u sebi, naći će ga svuda.',
    author: 'Ivo Andrić'
  ),
  Quote(
    text: 'Svet je podeljen na proganjane i one koji ih proganjaju.',
    author: 'Ivo Andrić'
  ),
  Quote(
    text: 'Jezik je dijalekat s vojskom iza sebe.',
    author: 'Dubravka Ugrešić'
  ),
  Quote(
    text: 'Život je dar, ali ne garantuje sreću.',
    author: 'Danilo Kiš'
  ),
  Quote(
    text: 'Život nije ono što smo preživeli, već ono što smo zapamtili i kako smo to zapamtili.',
    author: 'Aleksandar Tišma'
  ),
  Quote(
    text: 'Budućnost pripada onima koji veruju u lepotu svojih snova.',
    author: 'Miloš Crnjanski'
  ),
  // More Ivo Andrić quotes
  Quote(
    text: 'Svako od nas ima za drugoga neku svoju reč, i samo za njega.',
    author: 'Ivo Andrić'
  ),
  Quote(
    text: 'Sreća je kad se ljudi dobro slažu.',
    author: 'Ivo Andrić'
  ),
  Quote(
    text: 'Svi smo mi mrtvi, samo se redom sahranjujemo.',
    author: 'Ivo Andrić'
  ),
  Quote(
    text: 'Čovjek nije nikad sam, nego na jedan način kad se smije, a na drugi kad plače.',
    author: 'Ivo Andrić'
  ),
  Quote(
    text: 'Nije jezik ono što čita, nego ono što se razume.',
    author: 'Ivo Andrić'
  ),
  Quote(
    text: 'U životu ne dobivamo uvijek ono što želimo, nego ono što nam je suđeno.',
    author: 'Ivo Andrić'
  ),
  Quote(
    text: 'Bogat nije onaj ko mnogo ima, nego onaj ko mnogo daje.',
    author: 'Ivo Andrić'
  ),
  Quote(
    text: 'Tamo gdje prestaje razum, počinje ludost i mrak.',
    author: 'Ivo Andrić'
  ),
  
  // More Meša Selimović quotes
  Quote(
    text: 'Život je nerazumljiva pojava, jer uvijek ostaje tajna zašto se mora izgubiti.',
    author: 'Meša Selimović'
  ),
  Quote(
    text: 'Svako je, bar jedanput u životu, pobjednik. Ali samo hrabri znaju da je to uzaludno.',
    author: 'Meša Selimović'
  ),
  Quote(
    text: 'Teško je znati šta je čovjek, a najteže onaj koji smo mi sami.',
    author: 'Meša Selimović'
  ),
  Quote(
    text: 'Svi smo braća, samo smo na različitim stranama.',
    author: 'Meša Selimović'
  ),
  Quote(
    text: 'Ako ne možeš pametnija, možeš pamtljivija.',
    author: 'Meša Selimović'
  ),
  Quote(
    text: 'Čovek je uvek na gubitku ako ne ume da voli.',
    author: 'Meša Selimović'
  ),
  Quote(
    text: 'Sreća ne zavisi od drugih ljudi, nego od nas samih.',
    author: 'Meša Selimović'
  ),
  
  // More Miloš Crnjanski quotes
  Quote(
    text: 'Uvek idemo tamo gde nas ne čekaju.',
    author: 'Miloš Crnjanski'
  ),
  Quote(
    text: 'Ljubav, to je skok u provaliju, po svojoj volji, mada bismo se spasiti mogli.',
    author: 'Miloš Crnjanski'
  ),
  Quote(
    text: 'Da je srce ljudsko stanište vedrine, ne bi bilo toliko samoubistava.',
    author: 'Miloš Crnjanski'
  ),
  Quote(
    text: 'Mi smo svi, na ovom svetu, samo prolaznici.',
    author: 'Miloš Crnjanski'
  ),
  
  // More Miroslav Krleža quotes
  Quote(
    text: 'Knjige ne pišu da bi se u njih vjerovalo, nego da bi se o njima raspravljalo.',
    author: 'Miroslav Krleža'
  ),
  Quote(
    text: 'U laži su kratke noge, ali dugački rukavi.',
    author: 'Miroslav Krleža'
  ),
  Quote(
    text: 'Veliki uspjesi uvijek imaju duboke korijene.',
    author: 'Miroslav Krleža'
  ),
  Quote(
    text: 'Tko se nije nasmijao u suzama, taj ne zna ništa o životu.',
    author: 'Miroslav Krleža'
  ),
  Quote(
    text: 'Ako želiš dobro upoznati jedan narod, prouči kako se kod njega umire.',
    author: 'Miroslav Krleža'
  ),
  
  // Tin Ujević (Croatian)
  Quote(
    text: 'Čovjek se uvijek vraća sebi, svojim mukama.',
    author: 'Tin Ujević'
  ),
  Quote(
    text: 'Neka bude svjetlost, makar ona dolazila kroz moje kosti.',
    author: 'Tin Ujević'
  ),
  Quote(
    text: 'Tek jedno: biti svoj! I to je dosta.',
    author: 'Tin Ujević'
  ),
  Quote(
    text: 'Ljudska bol je jedna velika tajna.',
    author: 'Tin Ujević'
  ),
  Quote(
    text: 'Ima više istine u jednoj pesmi nego u svim novinama ovoga sveta.',
    author: 'Tin Ujević'
  ),
  
  // Branislav Nušić (Serbian)
  Quote(
    text: 'Od svega što sam u životu izgubio, najviše mi nedostaje moja pamet.',
    author: 'Branislav Nušić'
  ),
  Quote(
    text: 'Poštenje je retko kod nas, ali je zato skupo.',
    author: 'Branislav Nušić'
  ),
  Quote(
    text: 'Čovek se uči dok je živ, a umire neuk.',
    author: 'Branislav Nušić'
  ),
  Quote(
    text: 'Iskrenost je vrlina koja se sve ređe praktikuje.',
    author: 'Branislav Nušić'
  ),
  
  // Jovan Dučić (Serbian)
  Quote(
    text: 'Žene opraštaju onima koji čine brze i hrabre greške.',
    author: 'Jovan Dučić'
  ),
  Quote(
    text: 'Reči koje ne prate delo odlaze sa vetrom.',
    author: 'Jovan Dučić'
  ),
  Quote(
    text: 'Ljubaznost je zlato koje ne košta ništa.',
    author: 'Jovan Dučić'
  ),
  Quote(
    text: 'Prazninu u duši ne može ispuniti nijedna druga punina.',
    author: 'Jovan Dučić'
  ),
  
  // Vladislav Petković Dis (Serbian)
  Quote(
    text: 'Sutra je nova laž koja nam svima prija.',
    author: 'Vladislav Petković Dis'
  ),
  Quote(
    text: 'Ponekad su i snovi bolji od jave.',
    author: 'Vladislav Petković Dis'
  ),
  
  // August Šenoa (Croatian)
  Quote(
    text: 'Gdje nema slobode, nema ni života.',
    author: 'August Šenoa'
  ),
  Quote(
    text: 'Prošlost je ogledalo budućnosti.',
    author: 'August Šenoa'
  ),
  Quote(
    text: 'Ljubav nije samo slijepa, već često i gluhonijema.',
    author: 'August Šenoa'
  ),
  
  // Antun Gustav Matoš (Croatian)
  Quote(
    text: 'Bez oduševljenja se ne može ništa veliko učiniti.',
    author: 'Antun Gustav Matoš'
  ),
  Quote(
    text: 'Ljubav djevojci više puta slomi srce, ali mladost joj ga brzo zaliječi.',
    author: 'Antun Gustav Matoš'
  ),
  Quote(
    text: 'Umjetnost riječi je najteža i najljepša umjetnost.',
    author: 'Antun Gustav Matoš'
  ),
  
  // Branko Miljković (Serbian)
  Quote(
    text: 'Ubi me prejaka reč.',
    author: 'Branko Miljković'
  ),
  Quote(
    text: 'Pesnik je uvek na gubitku.',
    author: 'Branko Miljković'
  ),
  Quote(
    text: 'Hoće li sloboda umeti da peva kao što su sužnji pevali o njoj?',
    author: 'Branko Miljković'
  ),
  
  // Vasko Popa (Serbian)
  Quote(
    text: 'Između dva zla birati ne treba.',
    author: 'Vasko Popa'
  ),
  Quote(
    text: 'U snu sam ono što na javi želim da budem.',
    author: 'Vasko Popa'
  ),
  
  // Mak Dizdar (Bosnian)
  Quote(
    text: 'Pitaš me o putu, a put je pred nama.',
    author: 'Mak Dizdar'
  ),
  Quote(
    text: 'I nema smrti, postoji samo seoba.',
    author: 'Mak Dizdar'
  ),
  Quote(
    text: 'Zapisano je i pečatom potvrđeno da si prah. A nije zapisano da si samo prah.',
    author: 'Mak Dizdar'
  ),
  
  // Bora Đorđević (Serbian)
  Quote(
    text: 'Sreća je tamo gde je nema.',
    author: 'Bora Đorđević'
  ),
  Quote(
    text: 'Istina je negde drugde.',
    author: 'Bora Đorđević'
  ),
  
  // Dragan Velikić (Serbian)
  Quote(
    text: 'Ničeg goreg od zagubljenog sna.',
    author: 'Dragan Velikić'
  ),
  Quote(
    text: 'Život je samo mala stanica na putu između dva ništavila.',
    author: 'Dragan Velikić'
  ),
  
  // Jovan Sterija Popović (Serbian)
  Quote(
    text: 'Laž često pobedi, ali nikad ne pobeđuje.',
    author: 'Jovan Sterija Popović'
  ),
  Quote(
    text: 'Dobrom čoveku ne treba mnogo.',
    author: 'Jovan Sterija Popović'
  ),
  
  // Ranko Marinković (Croatian)
  Quote(
    text: 'Ljubav je smisao i opravdanje svega.',
    author: 'Ranko Marinković'
  ),
  Quote(
    text: 'Nitko nema monopol na patnju.',
    author: 'Ranko Marinković'
  ),
  
  // Marko Marulić (Croatian)
  Quote(
    text: 'Tko se Boga ne boji, taj se ni ljudi ne stidi.',
    author: 'Marko Marulić'
  ),
  Quote(
    text: 'Čovjek je rođen za rad, kao ptica za let.',
    author: 'Marko Marulić'
  ),
  
  // Isidora Sekulić (Serbian)
  Quote(
    text: 'Tišina je muzika duše.',
    author: 'Isidora Sekulić'
  ),
  Quote(
    text: 'Ljubav i istina uvek kasne, ali uvek stignu.',
    author: 'Isidora Sekulić'
  ),
  Quote(
    text: 'Snaga leži u različitosti, ne u sličnosti.',
    author: 'Isidora Sekulić'
  ),
  
  // Vesna Parun (Croatian)
  Quote(
    text: 'Sreća nije u tome što imaš, već u tome što jesi.',
    author: 'Vesna Parun'
  ),
  Quote(
    text: 'Suze su kapi čišćenja.',
    author: 'Vesna Parun'
  ),
  
  // Matija Bećković (Montenegrin/Serbian)
  Quote(
    text: 'Istorija je sve ono što se nije dalo ispraviti.',
    author: 'Matija Bećković'
  ),
  Quote(
    text: 'Ko nije verovao u Boga, poverovao je u čoveka, a ko je verovao u čoveka, prevario se.',
    author: 'Matija Bećković'
  ),
  Quote(
    text: 'Mi se davimo u peskovitim olujama svoje istorije.',
    author: 'Matija Bećković'
  ),
  
  // Miroslav Mika Antić (Serbian)
  Quote(
    text: 'Ko ne voli, taj ne razume ni sebe ni druge.',
    author: 'Miroslav Antić'
  ),
  Quote(
    text: 'Svi smo stvoreni za ljubav.',
    author: 'Miroslav Antić'
  ),
  Quote(
    text: 'Nema loših đaka, samo ima loših učitelja.',
    author: 'Miroslav Antić'
  ),
  
  // Petar Petrović Njegoš (Montenegrin)
  Quote(
    text: 'Ko ne želi umreti u borbi, taj će umreti u sramoti.',
    author: 'Petar Petrović Njegoš'
  ),
  Quote(
    text: 'Teško nogama pod ludom glavom.',
    author: 'Petar Petrović Njegoš'
  ),
  Quote(
    text: 'Bez muke se pjesna ne ispoja.',
    author: 'Petar Petrović Njegoš'
  ),
  Quote(
    text: 'Kome zakon leži u topuzu, tragovi mu smrde nečovještvom.',
    author: 'Petar Petrović Njegoš'
  ),
  
  // Laza Kostić (Serbian)
  Quote(
    text: 'Među javom i med snom.',
    author: 'Laza Kostić'
  ),
  Quote(
    text: 'Ljubav je nebo, zemlja i sve između.',
    author: 'Laza Kostić'
  ),
  
  // Aleksa Šantić (Bosnian/Serbian)
  Quote(
    text: 'Samo onaj koji stoji uspravno vidi daleko.',
    author: 'Aleksa Šantić'
  ),
  Quote(
    text: 'Domovinu voli svako, ali otadžbinu samo slobodan čovjek.',
    author: 'Aleksa Šantić'
  ),
  
  // Jovan Jovanović Zmaj (Serbian)
  Quote(
    text: 'Ko iskren je taj je i hrabar.',
    author: 'Jovan Jovanović Zmaj'
  ),
  Quote(
    text: 'Tuga je duboka kao more, a radost plitka kao potok.',
    author: 'Jovan Jovanović Zmaj'
  ),
  
  // Duško Radović (Serbian)
  Quote(
    text: 'Beograde, dobro jutro.',
    author: 'Duško Radović'
  ),
  Quote(
    text: 'Deca su ukras sveta.',
    author: 'Duško Radović'
  ),
  Quote(
    text: 'Život je uvek na pravoj strani.',
    author: 'Duško Radović'
  ),
  Quote(
    text: 'Ko rano rani, ne stigne ništa da uradi jer je pospan ceo dan.',
    author: 'Duško Radović'
  ),
  Quote(
    text: 'Ljudi koji mnogo očekuju od života - mnogo i dobiju, ali ne ono što su očekivali.',
    author: 'Duško Radović'
  ),
  
  // Borislav Pekić (Serbian)
  Quote(
    text: 'Srećan je onaj koji ima sve što želi, a mudar onaj koji ne želi ono što nema.',
    author: 'Borislav Pekić'
  ),
  Quote(
    text: 'Ništa se ne dešava onima koji ništa ne čine.',
    author: 'Borislav Pekić'
  ),
  
  // Emir Kusturica (Bosnian/Serbian)
  Quote(
    text: 'Život je nepravičan, a najnepravičniji je prema najpravičnijima.',
    author: 'Emir Kusturica'
  ),
  Quote(
    text: 'Smrt je samo još jedna laž.',
    author: 'Emir Kusturica'
  ),
  
  // Meša Selimović additional quotes
  Quote(
    text: 'Pisac piše ono što oseća i što ne može da sakrije.',
    author: 'Meša Selimović'
  ),
  Quote(
    text: 'Čovek je zato što misli.',
    author: 'Meša Selimović'
  ),
  Quote(
    text: 'Ne kaže se uzalud da je ćutanje zlato.',
    author: 'Meša Selimović'
  ),
  
  // Blaže Koneski (Macedonian)
  Quote(
    text: 'Svet nije ni lep ni ružan, već takav kakvim ga vidimo.',
    author: 'Blaže Koneski'
  ),
  Quote(
    text: 'Reči su most između ljudi.',
    author: 'Blaže Koneski'
  ),
  
  // Koča Popović (Serbian)
  Quote(
    text: 'Kad su vremena teška, treba biti jak.',
    author: 'Koča Popović'
  ),
  Quote(
    text: 'Ljudi koji znaju malo se bune mnogo, ljudi koji znaju mnogo se bune malo.',
    author: 'Koča Popović'
  ),
  
  // Slavko Janevski (Macedonian)
  Quote(
    text: 'Smej se i svet će se smejati s tobom.',
    author: 'Slavko Janevski'
  ),
  Quote(
    text: 'Teške reči ostavljaju duboke ožiljke.',
    author: 'Slavko Janevski'
  ),
  
  // Ivan Cankar (Slovenian)
  Quote(
    text: 'Domovina je ena nam samo dana.',
    author: 'Ivan Cankar'
  ),
  Quote(
    text: 'Čovjek koji ima srce, ima i dom.',
    author: 'Ivan Cankar'
  ),
  
  // Stevan Sremac (Serbian)
  Quote(
    text: 'Gde su dvoje, treći je suvišan.',
    author: 'Stevan Sremac'
  ),
  Quote(
    text: 'Onaj koji ne zna da ćuti, ne zna ni da govori.',
    author: 'Stevan Sremac'
  ),
  
  // Jovan Cvijić (Serbian)
  Quote(
    text: 'Narod koji zaboravlja svoju prošlost nema budućnost.',
    author: 'Jovan Cvijić'
  ),
  Quote(
    text: 'Čovek je pre svega dužan prema svom narodu.',
    author: 'Jovan Cvijić'
  ),
  
  // Dušan Radović (additional quotes)
  Quote(
    text: 'Budite dobri prema deci, da bi deca bila dobra prema vama kad porastete.',
    author: 'Duško Radović'
  ),
  Quote(
    text: 'Lepota nije u licu. Lepota je svetlost u srcu.',
    author: 'Duško Radović'
  ),
  Quote(
    text: 'Ne dozvolite da vam život prođe u čekanju da život počne.',
    author: 'Duško Radović'
  ),
  
  // Skender Kulenović (Bosnian)
  Quote(
    text: 'Nema bola koji vreme ne leči.',
    author: 'Skender Kulenović'
  ),
  Quote(
    text: 'U životu treba birati jednu od dve stvari: ili patiti ili biti dosadan.',
    author: 'Skender Kulenović'
  ),
  
  // Slavenka Drakulić (Croatian)
  Quote(
    text: 'Granice postoje samo u našim glavama.',
    author: 'Slavenka Drakulić'
  ),
  Quote(
    text: 'Prošlost ne možemo promijeniti, ali budućnost je u našim rukama.',
    author: 'Slavenka Drakulić'
  ),
  
  // Vladan Desnica (Croatian/Serbian)
  Quote(
    text: 'Vrijeme je vjetar koji, kako prolazi kroz nas, raznosi nas u sitne komadiće.',
    author: 'Vladan Desnica'
  ),
  Quote(
    text: 'Prolaznost je bolest od koje svi bolujemo.',
    author: 'Vladan Desnica'
  ),
];
