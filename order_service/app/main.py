from fastapi import FastAPI, HTTPException, Depends
from pydantic import BaseModel
from sqlalchemy.orm import Session
from datetime import date

from app.database import get_db
from app.models import Product, Order, OrderItem

app = FastAPI(title="Order Service")

class AddItemRequest(BaseModel):
    product_id: int
    quantity: int

@app.post("/orders/{order_id}/add-item")
def add_item_to_order(order_id: int, item: AddItemRequest, db: Session = Depends(get_db)):
    # Check order exists
    order = db.query(Order).filter(Order.id == order_id).first()
    if not order:
        raise HTTPException(status_code=404, detail="Order not found")

    # Check product exists
    product = db.query(Product).filter(Product.id == item.product_id).first()
    if not product:
        raise HTTPException(status_code=404, detail="Product not found")

    # Check stock availability
    if product.quantity < item.quantity:
        raise HTTPException(status_code=400, detail="Insufficient product stock")

    # Check if product already in order
    order_item = db.query(OrderItem).filter(OrderItem.order_id == order_id, OrderItem.product_id == item.product_id).first()

    if order_item:
        new_quantity = order_item.quantity + item.quantity
        if product.quantity < new_quantity:
            raise HTTPException(status_code=400, detail="Insufficient product stock for the updated quantity")
        order_item.quantity = new_quantity
    else:
        order_item = OrderItem(
            order_id=order_id,
            product_id=item.product_id,
            quantity=item.quantity,
            price=product.price
        )
        db.add(order_item)

    # Decrease product stock
    product.quantity -= item.quantity

    # Update order total price
    total = 0
    for oi in order.items:
        total += oi.quantity * oi.price
    order.total_price = total

    db.commit()
    db.refresh(order_item)
    return {"message": "Item added to order", "order_item": {"id": order_item.id, "quantity": order_item.quantity}}
