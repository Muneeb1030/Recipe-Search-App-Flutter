class RecipeModel {
  late String applabel;
  late String appimgUrl;
  late double appcalories;
  late String appurl;

  RecipeModel(
      {this.applabel = "LABEL",
      this.appcalories = 0.000,
      this.appimgUrl = "IMAGE",
      this.appurl = "URL"});

  factory RecipeModel.fromMap(Map Recipe) {
    return RecipeModel(
        applabel: Recipe["label"],
        appcalories: Recipe["calories"],
        appimgUrl: Recipe["image"],
        appurl: Recipe["url"]);
  }
}
