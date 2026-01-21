const Cart = require('../models/cart');

// POST para adicionar items ao carrinho
// Recebe userId do token e itemId do body
const addtocart = async (req, res) => { 
    try{
        // Extrai o userId do token decodificado (middleware de autenticação)
        const userId = req.userId;
        
        // Extrai o itemId do corpo da requisição
        const itemId = req.body.itemId;
        
        // Procura um carrinho existente para este userId
        let cart = await Cart.findOne({ userId: userId });
        
        if (cart) {
            // Se o carrinho já existe, adiciona o novo item ao array items
            cart.items.push({ itemId: itemId });
            await cart.save();
            res.json({ cart: cart });
        } else {
            // Se não existe carrinho, cria um novo com o primeiro item
            cart = new Cart({
                userId: userId,
                items: [{ itemId: itemId }]
            });
            await cart.save();
            res.json({ cart: cart });
        }
    }catch (error){ 
        // Retorna erro se algo deu errado (ex: erro de conexão com BD)
        res.status(500).json({ message: 'Erro ao adicionar ao carrinho' });
    }
}

// DELETE para remover um carrinho inteiro
// Recebe o cartId do body
const deleteitem = async (req, res) => { 
    try{
        // Extrai o cartId do corpo da requisição
        const cartId = req.body.cartId;
        
        // Encontra e deleta o carrinho pelo seu ID
        await Cart.deleteOne({ _id: cartId });
        
        // Retorna mensagem de sucesso
        res.json({ message: 'Carrinho removido com sucesso' });
    }catch (error){
        // Retorna erro se algo deu errado
        res.status(500).json({ message: 'Erro ao remover carrinho' });
    }
}

module.exports = {
    addtocart,
    deleteitem
};