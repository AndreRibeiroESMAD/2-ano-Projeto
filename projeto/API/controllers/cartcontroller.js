const Cart = require('../models/cart');

// POST para adicionar items ao carrinho
// Recebe userId do token e itemId do body
const addtocart = async (req, res) => { 
    try{
        // Extrai o userId do token decodificado (middleware de autenticação)
        const userId = req.userId;
        
        // Extrai o itemId do corpo da requisição
        const itemId = req.body.itemId;
        const quantity = req.body.quantity || 1;
        
        // Procura um carrinho existente para este userId
        let cart = await Cart.findOne({ userId: userId });
        
        if (cart) {
            // Verifica se o item já existe no carrinho
            const existingItem = cart.items.find(item => item.itemId.toString() === itemId);
            
            if (existingItem) {
                // Se existe, incrementa a quantidade
                existingItem.quantity += quantity;
            } else {
                // Se não existe, adiciona novo item
                cart.items.push({ itemId: itemId, quantity: quantity });
            }
            await cart.save();
            res.json({ cart: cart });
        } else {
            // Se não existe carrinho, cria um novo com o primeiro item
            cart = new Cart({
                userId: userId,
                items: [{ itemId: itemId, quantity: quantity }]
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

// GET para obter o carrinho do usuário
const getcart = async (req, res) => {
    try {
        // Extrai o userId do token (middleware de autenticação)
        const userId = req.userId;
        
        // Procura o carrinho do usuário e popula os items com os dados completos
        const cart = await Cart.findOne({ userId: userId }).populate('items.itemId');
        
        if (!cart) {
            return res.status(404).json({ message: 'Carrinho não encontrado' });
        }
        
        res.json({ cart: cart });
    } catch (error) {
        res.status(500).json({ message: 'Erro ao buscar carrinho' });
    }
}

// DELETE para remover um item específico do carrinho
const removeItemFromCart = async (req, res) => {
    try {
        const userId = req.userId;
        const itemId = req.params.itemId;
        
        const cart = await Cart.findOne({ userId: userId });
        
        if (!cart) {
            return res.status(404).json({ message: 'Carrinho não encontrado' });
        }
        
        // Remove o item do array de items
        cart.items = cart.items.filter(item => item.itemId.toString() !== itemId);
        await cart.save();
        
        res.json({ message: 'Item removido do carrinho', cart: cart });
    } catch (error) {
        res.status(500).json({ message: 'Erro ao remover item' });
    }
}

module.exports = {
    addtocart,
    deleteitem,
    getcart,
    removeItemFromCart
};