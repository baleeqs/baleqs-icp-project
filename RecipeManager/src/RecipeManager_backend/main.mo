import Buffer "mo:base/Buffer";
import Text "mo:base/Text";

actor {
  type Ingredient = {
    name: Text;
    amount: Nat;
    unit: Text;
  };

  type Recipe = {
    id: Nat;
    name: Text;
    ingredients: [Ingredient];
    instructions: [Text];
    servings: Nat;
  };

  var recipes = Buffer.Buffer<Recipe>(0);

  public func addRecipe(name: Text, ingredients: [Ingredient], instructions: [Text], servings: Nat) : async Nat {
    let id = recipes.size();
    let newRecipe: Recipe = {
      id;
      name;
      ingredients;
      instructions;
      servings;
    };
    recipes.add(newRecipe);
    id
  };

  public query func getRecipe(id: Nat) : async ?Recipe {
    if (id >= recipes.size()) return null;
    ?recipes.get(id)
  };

  public func updateRecipe(id: Nat, name: ?Text, ingredients: ?[Ingredient], instructions: ?[Text], servings: ?Nat) : async Bool {
    if (id >= recipes.size()) return false;
    let recipe = recipes.get(id);
    let updatedRecipe: Recipe = {
      id = recipe.id;
      name = switch (name) { case (null) recipe.name; case (?n) n };
      ingredients = switch (ingredients) { case (null) recipe.ingredients; case (?i) i };
      instructions = switch (instructions) { case (null) recipe.instructions; case (?i) i };
      servings = switch (servings) { case (null) recipe.servings; case (?s) s };
    };
    recipes.put(id, updatedRecipe);
    true
  };

  public query func lookup(name : Text) : async ?Recipe {
  for (recipe in recipes.vals()) {
    if (Text.equal(recipe.name, name)) {
      return ?recipe;
    };
  };
  null
  };
}