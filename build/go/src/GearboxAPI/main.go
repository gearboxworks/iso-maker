package main

import (
	"encoding/json"
	"github.com/gorilla/mux"
	"log"
	"fmt"
	"time"
	"os"
	"syscall"
	"os/signal"
	"net/http"
)

// The person Type (more like an object)
type Person struct {
	ID        string   `json:"id,omitempty"`
	Firstname string   `json:"firstname,omitempty"`
	Lastname  string   `json:"lastname,omitempty"`
	Address   *Address `json:"address,omitempty"`
}
type Address struct {
	City  string `json:"city,omitempty"`
	State string `json:"state,omitempty"`
}

var people []Person


// Display all from the people var
func State(w http.ResponseWriter, r *http.Request) {
	fmt.Printf("%v	GearBoxAPI - State().\n", time.Now().Unix());

}


// Display all from the people var
func PowerOff(w http.ResponseWriter, r *http.Request) {
	fmt.Printf("%v	GearBoxAPI - PowerOff().\n", time.Now().Unix());

	time.Sleep(time.Second)

	err := syscall.Exec("/sbin/poweroff", []string{""}, os.Environ())
	if err != nil {
		fmt.Printf("%v	GearBoxAPI - Ooops! Can't power off GearBox...\n", time.Now().Unix());
	}
}


// Display all from the people var
func GetPeople(w http.ResponseWriter, r *http.Request) {
	fmt.Printf("%v	GearBoxAPI - GetPeople().\n", time.Now().Unix());

	json.NewEncoder(w).Encode(people)
}

// Display a single data
func GetPerson(w http.ResponseWriter, r *http.Request) {
	fmt.Printf("%v	GearBoxAPI - GetPerson().\n", time.Now().Unix());

	params := mux.Vars(r)
	for _, item := range people {
		if item.ID == params["id"] {
			json.NewEncoder(w).Encode(item)
			return
		}
	}
	json.NewEncoder(w).Encode(&Person{})
}

// create a new item
func CreatePerson(w http.ResponseWriter, r *http.Request) {
	fmt.Printf("%v	GearBoxAPI - CreatePerson().\n", time.Now().Unix());

	params := mux.Vars(r)
	var person Person
	_ = json.NewDecoder(r.Body).Decode(&person)
	person.ID = params["id"]
	people = append(people, person)
	json.NewEncoder(w).Encode(people)
}

// Delete an item
func DeletePerson(w http.ResponseWriter, r *http.Request) {
	fmt.Printf("%v	GearBoxAPI - DeletePerson().\n", time.Now().Unix());

	params := mux.Vars(r)
	for index, item := range people {
		if item.ID == params["id"] {
			people = append(people[:index], people[index+1:]...)
			break
		}
		json.NewEncoder(w).Encode(people)
	}
}

// main function to boot up everything
func main() {
	// //////////////////////////////////////////////////////////
	// Handle ctrl-c and other signals.
	handleSignal := make(chan os.Signal, 1)
	signal.Notify(handleSignal, os.Interrupt)
	go func(){
		for sig := range handleSignal {
			fmt.Printf("%v	GearBoxAPI - Died on signal %s.\n", time.Now().Unix(), sig);
			time.Sleep(time.Second)
			os.Exit(1)
		}
	}()

	fmt.Printf("%v	GearBoxAPI - Starting.\n", time.Now().Unix());
	go Worker()
	for {
		time.Sleep(time.Second * 2)
		fmt.Printf("%v;GearBox API;OK;\n", time.Now().Unix());
	}

	fmt.Printf("%v	GearBoxAPI - Listener died.\n", time.Now().Unix());
}

func Worker() {
	router := mux.NewRouter()
	people = append(people, Person{ID: "1", Firstname: "John", Lastname: "Doe", Address: &Address{City: "City X", State: "State X"}})
	people = append(people, Person{ID: "2", Firstname: "Koko", Lastname: "Doe", Address: &Address{City: "City Z", State: "State Y"}})

	router.HandleFunc("/", GetPeople).Methods("GET")

	router.HandleFunc("/state", State).Methods("GET")
	router.HandleFunc("/state/off", PowerOff).Methods("GET")

	router.HandleFunc("/people", GetPeople).Methods("GET")
	router.HandleFunc("/people/{id}", GetPerson).Methods("GET")
	router.HandleFunc("/people/{id}", CreatePerson).Methods("POST")
	router.HandleFunc("/people/{id}", DeletePerson).Methods("DELETE")

	err := http.ListenAndServe(":9970", router)
	if err != nil {
		log.Fatal(http.ListenAndServe(":9970", router))
	}
}