package main

// https://developers.cloudflare.com/api/go/resources/dns/subresources/records/methods/list/
// https://developers.cloudflare.com/api/go/resources/dns/subresources/records/methods/delete/

import (
	"context"
	"fmt"
	"os"

	"github.com/cloudflare/cloudflare-go/v3"
	"github.com/cloudflare/cloudflare-go/v3/dns"
	"github.com/cloudflare/cloudflare-go/v3/option"
	"github.com/joho/godotenv"
)

func main() {
	var err error

	err = godotenv.Load()
	if err != nil {
		fmt.Println("Error loading .env file:", err)
		return
	}

	email := os.Getenv("CLOUDFLARE_EMAIL")
	apiKey := os.Getenv("CLOUDFLARE_API_KEY")
	zone1 := "3ba5d048f4d88833ae1e2638ad57ee64" // sikademo1.uk
	zone2 := "dd0036cc8abdf8d12eb9a8cc150d9f08" // sikademo2.uk
	zone3 := "db23d39fbe9feaf207f0007680022fbc" // sikademo3.uk

	for _, zone := range []string{zone1, zone2, zone3} {
		err = deleteAllDnsRecords(email, apiKey, zone)
		if err != nil {
			fmt.Println("Error deleting DNS records:", err)
		}
	}
}

func deleteAllDnsRecords(email, apiKey, zoneID string) error {
	var err error

	client := cloudflare.NewClient(
		option.WithAPIEmail(email),
		option.WithAPIKey(apiKey),
	)

	page, err := client.DNS.Records.List(context.TODO(), dns.RecordListParams{
		ZoneID: cloudflare.F(zoneID),
	})
	if err != nil {
		return fmt.Errorf("failed to list DNS records: %w", err)
	}

	for _, record := range page.Result {
		fmt.Println("Deleting record:", record.Name)
		_, err = client.DNS.Records.Delete(
			context.TODO(),
			record.ID,
			dns.RecordDeleteParams{
				ZoneID: cloudflare.F(zoneID),
			},
		)
		if err != nil {
			return fmt.Errorf("failed to delete DNS record %s: %w", record.Name, err)
		}
	}

	return nil
}
