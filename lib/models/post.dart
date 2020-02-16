class PostModel {
  final String post;
  final String username;
  final String time;
  final String userHandle;
  final String imagePath;
  final bool isLiked;

  PostModel(this.post, this.username, this.time, this.userHandle,
      this.imagePath, this.isLiked);
}

final mockPosts = [
  PostModel(
      "#plusSapienza\n\nVolete mettere a posto il curriculum? Gli #studentiSapienza"
          "hanno a disposizione un servizio gratuito di \"Cv Check\" a Porta Futuro Lazio"
          "#PfLazio! [tutte le info su ➡️ bit.ly/2tntZGr]\n\n"
          "(scopri questa e altre #opportunità su Porta Futuro Lazio)",
      "Sapienza Università di Roma",
      "5m",
      "@SapienzaRoma",
      "assets/images/sapienza_logo.jpg",
      true),
  PostModel(
      "Anche il professor Carlo Baroni, geologo dell’#Unipi e unico Italiano,"
          "fra i 38 scienziati firmatari della lettera appello pubblicata sulla"
          "rivista Nature che denuncia l'allarme dello scioglimento dei #ghiacciai.",
      "Università di Pisa",
      "10m",
      "@unipisaofficial",
      "assets/images/unipi_logo.jpg",
      false),
  PostModel(
      "Developing a large, complex app that needs a microservice architecture? @crichardson. Read on to learn how to  decompose an application into services ",
      "Java",
      "15m",
      "@java",
      "assets/images/sapienza_logo.jpg",
      true),
  PostModel(
      "The Samsung Galaxy S9 is in the record books now, but it's not likely that Samsung will be celebrating this particular milestone. https://www.androidauthority.com/samsung-galaxy-s9-history-887809/ … #samsung #samsunggalaxys9 by: C. Scott Brown",
      "Android Authority",
      "30m",
      "@AndroidAuth",
      "assets/images/sapienza_logo.jpg",
      false),
];
