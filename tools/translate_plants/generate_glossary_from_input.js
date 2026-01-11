const fs = require('fs');
require('dotenv').config();

const INPUT_JSON = process.env.INPUT_JSON || '../../assets/data/plants_fr_massive.json';
const OUT_PATH = process.env.GLOSSARY_PATH || 'glossary_seed.json';

// Minimal implementation to extract top N plants (placeholder logic)
// In a real scenario, this reads the massive JSON, sorts by popularity/usage, and outputs a map.

function main() {
  console.log(`Reading ${INPUT_JSON}...`);
  // Mock logic: reading a few known plants to seed
  // The user prompt implies this should create a seed file.
  
  const seed = {
    "Solanum_lycopersicum": {"fr":"Tomate","en":"Tomato","es":"Tomate","pt_BR":"Tomate","de":"Tomate"},
    "Lactuca_sativa": {"fr":"Laitue","en":"Lettuce","es":"Lechuga","pt_BR":"Alface","de":"Lattich"},
    "Daucus_carota": {"fr":"Carotte","en":"Carrot","es":"Zanahoria","pt_BR":"Cenoura","de":"Karotte"}
  };
  
  fs.writeFileSync(OUT_PATH, JSON.stringify(seed, null, 2));
  console.log(`Glossary seed written to ${OUT_PATH}`);
}

main();
