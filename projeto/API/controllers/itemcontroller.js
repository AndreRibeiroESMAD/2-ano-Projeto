const { validationResult } = require('express-validator');
const Item = require('../models/item');



//POST para adicionar items
const add = async (req, res) => {

    try{
         
   const name = req.body.name
   const price = req.body.price
   const description = req.body.description
   const ownerId = req.userId // Get from auth middleware

    const newitem = new Item({
        name: name,
        price: price,
        description: description,
        ownerId: ownerId
        })

    await newitem.save()

    res.json({newitem})
    }catch (error){ 
        res.status(500).json({ message: 'Erro ao adicionar item' });
    }
   
}

//GET de todos os items
const get = async (req, res) => {
    try {
        const items = await Item.find();

        res.json({ items });
    } catch (error) {
        res.status(500).json({ message: 'Erro ao buscar items' });
    }
}

//GET items do utilizador autenticado
const getMyItems = async (req, res) => {
    try {
        const userId = req.userId;
        const items = await Item.find({ ownerId: userId });

        res.json({ items });
    } catch (error) {
        res.status(500).json({ message: 'Erro ao buscar items' });
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
        const userId = req.userId;
        const name = req.body.name;
        const price = req.body.price;
        const description = req.body.description;

        // Verificar se o item pertence ao usuário
        const item = await Item.findById(itemId);
        if (!item) {
            return res.status(404).json({ message: 'Item não encontrado' });
        }
        if (item.ownerId.toString() !== userId) {
            return res.status(403).json({ message: 'Não autorizado' });
        }

        const updatedItem = await Item.findByIdAndUpdate(
            itemId,
            { name: name, price: price, description: description },
            { new: true }
        );

        res.json({ updatedItem });
    } catch (error) {
        res.status(500).json({ message: 'Erro ao editar item' });
    }
}

//DELETE para remover um item
const deleteItem = async (req, res) => {
    try {
        const itemId = req.params.id;
        const userId = req.userId;
        
        // Verificar se o item pertence ao usuário
        const item = await Item.findById(itemId);
        if (!item) {
            return res.status(404).json({ message: 'Item não encontrado' });
        }
        if (item.ownerId.toString() !== userId) {
            return res.status(403).json({ message: 'Não autorizado' });
        }

        const deletedItem = await Item.findByIdAndDelete(itemId);
        res.json({ message: 'Item removido com sucesso' });
    } catch (error) {
        res.status(500).json({ message: 'Erro ao remover item' });
    }
}

module.exports = {
  add,
  get,
  getitem,
  edit,
  deleteItem,
  getMyItems
};