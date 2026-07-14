# PRD 02 — Personas & User Stories

## 1. Personas

### Owner / Manager (Admin App)

| Attribute | Detail |
|-----------|--------|
| Name | Rajesh |
| Role | Restaurant owner |
| Tech level | Moderate — comfortable with phones/tablets |
| Goals | Run the restaurant profitably, track sales, manage staff |
| Pain points | High POS fees, internet outages break his current system, can't track which waiter served which table |

### Waiter (Waiter App)

| Attribute | Detail |
|-----------|--------|
| Name | Priya |
| Role | Waitstaff |
| Tech level | Basic — uses phone for messaging |
| Goals | Take orders quickly, know which tables are hers, send orders to kitchen |
| Pain points | Walking to a terminal to place orders, paper tickets get lost |

### Chef (Kitchen App)

| Attribute | Detail |
|-----------|--------|
| Name | Hassan |
| Role | Head chef |
| Tech level | Low — needs simple, visual interface |
| Goals | See orders as they come in, organize by station, mark items ready |
| Pain points | Yelling across the kitchen, lost paper KOTs, can't tell waiter when food is ready |

### Customer (Display App)

| Attribute | Detail |
|-----------|--------|
| Name | Ananya |
| Role | Dine-in customer |
| Tech level | Varies |
| Goals | Know when her order is ready without asking |
| Pain points | Waiting without status updates, unsure if order was received |

---

## 2. User Stories by Priority

### P0 — Must Have for MVP

| ID | Story | App |
|----|-------|-----|
| US01 | As an owner, I want to set up my restaurant profile (name, logo, address, currency, tax regime). | Admin |
| US02 | As an owner, I want to add/manage products with categories, prices, and tax slabs. | Admin |
| US03 | As an owner, I want to add staff members with role-specific PINs. | Admin |
| US04 | As an owner, I want to view and manage orders (active, completed, voided). | Admin |
| US05 | As an owner, I want to process payments (cash, card, UPI, wallet). | Admin |
| US06 | As an owner, I want to manage dining tables and see their status. | Admin |
| US07 | As a waiter, I want to log in with my own PIN. | Waiter |
| US08 | As a waiter, I want to view a table layout and see which tables are occupied/free. | Waiter |
| US09 | As a waiter, I want to open orders, add items, and checkout. | Waiter |
| US10 | As a chef, I want to see new orders in real-time on a KDS screen. | KDS |
| US11 | As a chef, I want to acknowledge orders and mark items as ready. | KDS |
| US12 | As a customer, I want to see my order status on a display screen. | Display |

### P1 — Important

| ID | Story | App |
|----|-------|-----|
| US13 | As an owner, I want to view daily sales reports and Z/X reports. | Admin |
| US14 | As an owner, I want to track inventory with stock counts and low-stock alerts. | Admin |
| US15 | As a waiter, I want to print KOT to the kitchen printer. | Waiter |
| US16 | As a waiter, I want to see which of my tables have pending orders. | Waiter |
| US17 | As a chef, I want to see orders filtered by station. | KDS |
| US18 | As a chef, I want sound/visual alerts for new orders. | KDS |

### P2 — Nice to Have

| ID | Story | App |
|----|-------|-----|
| US19 | As an owner, I want sales charts and trends on the dashboard. | Admin |
| US20 | As an owner, I want a visual table floor plan. | Admin |
| US21 | As a waiter, I want to mark orders as served. | Waiter |
| US22 | As a customer, I want to see my order number on the display. | Display |

### P3 — Future

| ID | Story | App |
|----|-------|-----|
| US23 | As an owner, I want multi-location reporting via cloud sync. | Admin |
| US24 | As an owner, I want remote monitoring from home. | Admin |
| US25 | As an owner, I want online ordering integration. | Admin |
