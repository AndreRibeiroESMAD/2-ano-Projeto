const { validationResult } = require('express-validator');
const Item = require('../models/item');



//POST para adicionar items
const add = async (req, res) => {

    try{
         
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

//GET de todos os items
const get = async (req, res) => {
    try {
        const items = await Item.find();

        res.json({ items });
    } catch (error) {

    }
}

//GET de item por ID
const getitem = async (req, res) => {
    try {
        const itemId = req.params.id;
        const item = await Item.findById(itemId);

        if (!item) {
            return res.status(404).json({ message: 'Item não encontrado' });
        }else {
            res.json({ item });
        }
    } catch (error) {

    }
}

//PUT para editar um item
const edit = async (req, res) => {
    try {
        const itemId = req.params.id;
        const name = req.body.name;
        const price = req.body.price;
        const description = req.body.description;

        const updatedItem = await Item.findByIdAndUpdate(
            itemId,
            { name: name, price: price, description: description },
            { new: true }
        );

        if (!updatedItem) {
            return res.status(404).json({ message: 'Item não encontrado' });
        } else {
            res.json({ updatedItem });
        }
    } catch (error) {

    }
}

//DELETE para remover um item
const deleteItem = async (req, res) => {
    try {
        const itemId = req.params.id;
        
        const deletedItem = await Item.findByIdAndDelete(itemId);

        if (!deletedItem) {
            return res.status(404).json({ message: 'Item não encontrado' });
        } else {
            res.json({ message: 'Item removido com sucesso' });
        }
    } catch (error) {

    }
}

module.exports = {
  add,
  get,
  getitem,
  edit,
  deleteItem
};