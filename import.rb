# Use this file to import the sales information into the
# the database.

require "pg"
require "csv"
require "pry"

def db_connection
  begin
    connection = PG.connect(dbname: "korning")
    yield(connection)
  ensure
    connection.close
  end
end

CSV.foreach("sales.csv", headers: true) do |row|
  @name = row[0].split(' ')[0..1].join(' ')
  @email = row[0].split(' ')[2]

  db_connection do |conn|
    @existing_email = conn.exec("SELECT email FROM employees").first["email"]
  end

  if @email != @existing_email

    db_connection do |conn|
      conn.exec("INSERT INTO employees (name, email) VALUES ('#{@name}', '#{@email}')")
    end
  end
end

CSV.foreach("sales.csv", headers: true) do |row|
  data = row.to_h
  @customers_name = data["customer_and_account_no"].split(' ')[0]
  @customers_email =  data["customer_and_account_no"].split(' ')[1]

  db_connection do |conn|
    @existing_customers_email = conn.exec("SELECT email FROM customers").first["email"]
  end

  if @customers_email != @existing_email

    db_connection do |conn|
      conn.exec("INSERT INTO customers (name, email) VALUES ('#{@customers_name}', '#{@customers_email}')")
    end
  end
end


CSV.foreach("sales.csv", headers: true) do |row|
  data = row.to_h
  @product_name = data["product_name"]

  db_connection do |conn|
    conn.exec("INSERT INTO products (name) VALUES ('#{@product_name}')")
  end
end

CSV.foreach("sales.csv", headers: true) do |row|
  data = row.to_h
  @invoice_frequency = data["invoice_frequency"]

  db_connection do |conn|
    conn.exec("INSERT INTO invoice_frequency (name) VALUES ('#{@invoice_frequency}')")
  end
end

CSV.foreach("sales.csv", headers: true) do |row|
  data = row.to_h
  @sale_date = data["sale_date"]
  @sale_amount = data["sale_amount"]
  @units_sold = data["units_sold"]
  @invoice_no = data["invoice_no"]

  db_connection do |conn|
    @employee_id = conn.exec("SELECT id FROM employees WHERE email = '#{@email}'").first['id']
    @customer_id = conn.exec("SELECT id FROM customers WHERE email = '#{@customers_email}'").first['id']
    @product_id = conn.exec("SELECT id FROM products WHERE name = '#{@product_name}'").first['id']
    @frequency_id = conn.exec("SELECT id FROM invoice_frequency WHERE name = '#{@invoice_frequency}'").first['id']

    conn.exec("INSERT INTO sales (employee_id, customer_id, product_id, sale_date, sale_amount, units_sold, invoice_no, frequency_id ) VALUES ('#{@employee_id}', '#{@customer_id}', '#{@product_id}', '#{@sale_date}', '#{@sale_amount}', '#{@units_sold}', '#{@invoice_no}', '#{@frequency_id}' )")
  end
end
