package main

import (
	"bytes"
	"log"
	"time"
	"context"
	
	"github.com/streadway/amqp"
	"go.etcd.io/etcd/clientv3"
)

func failOnError(err error, msg string) {
	if err != nil {
		log.Fatalf("%s: %s", msg, err)
	}
}

func main() {
	conn, err := amqp.Dial("amqp://guest:guest@localhost:5672/")
	failOnError(err, "No se ha conectado RabbitMQ")
	defer conn.Close()

	ch, err := conn.Channel()
	failOnError(err, "No se ha abierto el canal")
	defer ch.Close()

	// Configura etcd
	client, err := clientv3.New(clientv3.Config{
		Endpoints:   []string{"localhost:2379", "localhost:22379", "localhost:32379"},
		DialTimeout: 5 * time.Second,
	})
	if err != nil {
		log.Fatal(err)
	}
	ctx, _ := context.WithTimeout(context.Background(), 5 * time.Second)

	resp, err := client.Get(ctx, "exchange_name")
	exchange_name := string(resp.Kvs[0].Value)

	// RabbitMQ ahora
	err = ch.ExchangeDeclare(
		exchange_name, // name
		"fanout",     // type
		false,     // durable
                false,    // auto-deleted
                false,    // internal
                false,    // no-wait
                nil,      // arguments
	)
	failOnError(err, "No se ha declarado la el eschange")

	err = ch.Qos(
		1,     // prefetch count
		0,     // prefetch size
		false, // global
	)
	failOnError(err, "No funciona la calidad de servicio")

	q, err := ch.QueueDeclare(
		"",    // name
		false, // durable
		false, // delete when usused
		true,  // exclusive
		false, // no-wait
		nil,   // arguments
	)

	err = ch.QueueBind(
		q.Name, // queue name
		"",     // routing key
		exchange_name, // exchange
		false,
		nil,
	)
	
	msgs, err := ch.Consume(
		q.Name, // queue
		"",     // consumer
		false,  // auto-ack
		false,  // exclusive
		false,  // no-local
		false,  // no-wait
		nil,    // args
	)
	failOnError(err, "Failed to register a consumer")

	forever := make(chan bool)

	go func() {
		for d := range msgs {
			log.Printf("Recibido mensaje: %s", d.Body)
			dot_count := bytes.Count(d.Body, []byte("."))
			t := time.Duration(dot_count)
			time.Sleep(t * time.Second)
			log.Printf("Done")
			d.Ack(false)
		}
	}()

	log.Printf(" [*] Esperando mensajes. Sal con CTRL+C")
	<-forever
}
