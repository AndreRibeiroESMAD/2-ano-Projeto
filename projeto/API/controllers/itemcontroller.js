const { validationResult } = require('express-validator');
const Item = require('../models/item');


const add = async (req, res) => {

    try{
         console.log("teste")
    
   const name = req.body.name
   const price = req.body.price
   const description = req.body.description

    const newitem = new Item({
        name: name,
        price: price,
        description: description
        })

    await newitem.save()

    res.json({newitem})
    }catch (error){ 

    }
   
}

const get = async (req, res) => {
    try {
        const items = await Item.find();

        res.json({ items });
    } catch (error) {

    }
}

module.exports = {
  add,
  get
};