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


/////////////////////////////////
// WARNING!
//
// This is just some rubbish code as a place-holder.
// The only critical thing is that prints to STDOUT every 5 seconds the status.
// This will be used by the GoLang host executable to determine correct operational state.
//
//




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

// var people []Person


type State struct {
	Links Links `json:"links,omitempty"`
	Services []Services `json:"services,omitempty"`
}

type Services struct {
	Name  string `json:"name,omitempty"`
	State string `json:"state,omitempty"`
}

type 	Links struct {
	Self string `json:"self,omitempty"`
	State string `json:"state,omitempty"`
	Power string `json:"power,omitempty"`
	Parent string `json:"parent,omitempty"`
}


func ShowState(w http.ResponseWriter, r *http.Request) {
	var services []Services
	var states State

	fmt.Printf("%v	GearboxAPI - State().\n", time.Now().Unix());

	var links = Links{
		Self: "https://gearbox.local/state",
		Parent: "https://gearbox.local/",
	}

	vm := Services{
		Name: "vm",
		State: "OK",
	}
	services = append(services, vm)

	api := Services{
		Name: "api",
		State: "OK",
	}
	services = append(services, api)

	states = State{
		Services: services,
		Links: links,
	}

	json.NewEncoder(w).Encode(states)
}


type Power struct {
	Links Links `json:"links,omitempty"`
	Options []PowerOptions `json:"power,omitempty"`
}

type PowerOptions struct {
	Name  string `json:"name,omitempty"`
	State string `json:"state,omitempty"`
}

func PowerOff(w http.ResponseWriter, r *http.Request) {

	var options []PowerOptions
	var power Power

	fmt.Printf("%v	GearboxAPI - PowerOff().\n", time.Now().Unix());

	var links = Links{
		Self: "https://gearbox.local/power",
		Parent: "https://gearbox.local/",
	}

	api := PowerOptions{
		Name: "off",
		State: "OK",
	}
	options = append(options, api)

	power = Power{
		Options: options,
		Links: links,
	}

	json.NewEncoder(w).Encode(power)


	// time.Sleep(time.Second)

	err := syscall.Exec("/sbin/poweroff", []string{""}, os.Environ())
	if err != nil {
		fmt.Printf("%v	GearboxAPI - Ooops! Can't power off GearBox...\n", time.Now().Unix());
	}
}


func PowerState(w http.ResponseWriter, r *http.Request) {

	var options []PowerOptions
	var power Power

	fmt.Printf("%v	GearboxAPI - PowerState().\n", time.Now().Unix());

	var links = Links{
		Self: "https://gearbox.local/power",
		Parent: "https://gearbox.local/",
	}

	vm := PowerOptions{
		Name: "on",
		State: links.Self + "/on",
	}
	options = append(options, vm)

	api := PowerOptions{
		Name: "off",
		State: links.Self + "/off",
	}
	options = append(options, api)

	power = Power{
		Options: options,
		Links: links,
	}

	json.NewEncoder(w).Encode(power)
}



type Root struct {
	Links Links `json:"links,omitempty"`
	Info string `json:"info,omitempty"`
	Version string `json:"version,omitempty"`
}

func RootPage(w http.ResponseWriter, r *http.Request) {
	fmt.Printf("%v	GearboxAPI - GetPeople().\n", time.Now().Unix());

	var links = Links{
		Self: "https://gearbox.local/",
		State: "https://gearbox.local/state",
		Power: "https://gearbox.local/power",
	}

	root := Root{
		Links: links,
		Info: "Gearbox API",
		Version: "0.5.0",
	}

	json.NewEncoder(w).Encode(root)
}


// main function to boot up everything
func main() {
	// //////////////////////////////////////////////////////////
	// Handle ctrl-c and other signals.
	handleSignal := make(chan os.Signal, 1)
	signal.Notify(handleSignal, os.Interrupt)
	go func(){
		for sig := range handleSignal {
			fmt.Printf("%v	GearboxAPI - Died on signal %s.\n", time.Now().Unix(), sig);
			time.Sleep(time.Second)
			os.Exit(1)
		}
	}()

	fmt.Printf("%v	GearboxAPI - Starting.\n", time.Now().Unix());
	go Worker()
	for {
		time.Sleep(time.Second * 2)
		fmt.Printf("%v;Gearbox API;OK;\n", time.Now().Unix());
	}

	fmt.Printf("%v	GearboxAPI - Listener died.\n", time.Now().Unix());
}

func Worker() {
	router := mux.NewRouter()
	// people = append(people, Person{ID: "1", Firstname: "John", Lastname: "Doe", Address: &Address{City: "City X", State: "State X"}})
	// people = append(people, Person{ID: "2", Firstname: "Koko", Lastname: "Doe", Address: &Address{City: "City Z", State: "State Y"}})
	//	router.HandleFunc("/people", GetPeople).Methods("GET")
	//	router.HandleFunc("/people/{id}", GetPerson).Methods("GET")
	//	router.HandleFunc("/people/{id}", CreatePerson).Methods("POST")
	//	router.HandleFunc("/people/{id}", DeletePerson).Methods("DELETE")


	router.HandleFunc("/", RootPage).Methods("GET")
	router.HandleFunc("/state", ShowState).Methods("GET")
	router.HandleFunc("/power", PowerState).Methods("GET")
	router.HandleFunc("/power/off", PowerOff).Methods("GET")


	err := http.ListenAndServe(":9970", router)
	fmt.Printf("sds\n")
	if err != nil {
		log.Fatal(http.ListenAndServe(":9970", router))
	}
}


/*
// Display a single data
func GetPerson(w http.ResponseWriter, r *http.Request) {
	fmt.Printf("%v	GearboxAPI - GetPerson().\n", time.Now().Unix());


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
	fmt.Printf("%v	GearboxAPI - CreatePerson().\n", time.Now().Unix());

	params := mux.Vars(r)
	var person Person
	_ = json.NewDecoder(r.Body).Decode(&person)
	person.ID = params["id"]
	people = append(people, person)
	json.NewEncoder(w).Encode(people)
}

// Delete an item
func DeletePerson(w http.ResponseWriter, r *http.Request) {
	fmt.Printf("%v	GearboxAPI - DeletePerson().\n", time.Now().Unix());

	params := mux.Vars(r)
	for index, item := range people {
		if item.ID == params["id"] {
			people = append(people[:index], people[index+1:]...)
			break
		}
		json.NewEncoder(w).Encode(people)
	}
}
*/
