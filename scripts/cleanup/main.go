package main

// https://developers.cloudflare.com/api/go/resources/dns/subresources/records/methods/list/
// https://developers.cloudflare.com/api/go/resources/dns/subresources/records/methods/delete/
// https://developers.cloudflare.com/api/go/resources/zero_trust/subresources/tunnels/subresources/cloudflared/methods/list/
// https://developers.cloudflare.com/api/go/resources/zero_trust/subresources/tunnels/subresources/cloudflared/methods/delete/
// https://developers.cloudflare.com/api/go/resources/accounts/subresources/tokens/methods/list/
// https://developers.cloudflare.com/api/go/resources/accounts/subresources/tokens/methods/delete/

import (
	"context"
	"fmt"
	"log"
	"os"

	"github.com/cloudflare/cloudflare-go/v3"
	"github.com/cloudflare/cloudflare-go/v3/dns"
	"github.com/cloudflare/cloudflare-go/v3/option"
	"github.com/cloudflare/cloudflare-go/v3/user"
	"github.com/cloudflare/cloudflare-go/v3/zero_trust"
	"github.com/joho/godotenv"
)

func main() {
	var err error

	err = godotenv.Load()
	if err != nil {
		fmt.Println("Error loading .env file:", err)
		return
	}

	email := "cloudflare-demo-1@ondrejsikamail.com"
	apiKey := os.Getenv("CLOUDFLARE_API_KEY")
	accountID := "3d7bdb59b6b0972641e6dc9c2b2b9ade" // cloudflare-demo-1@ondrejsikamail.com account
	zone1 := "3ba5d048f4d88833ae1e2638ad57ee64"     // sikademo1.uk zone
	zone2 := "dd0036cc8abdf8d12eb9a8cc150d9f08"     // sikademo2.uk zone
	zone3 := "db23d39fbe9feaf207f0007680022fbc"     // sikademo3.uk zone
	zone4 := "014c02da23be8dfd741782892878296f"     // sikademo4.uk zone

	err = deleteAllTokens(email, apiKey)
	handleErrorFatal(err)

	err = deleteAllTunnels(email, apiKey, accountID)
	handleErrorFatal(err)

	err = deleteAllZeroTrustApplications(email, apiKey, accountID)
	handleErrorFatal(err)

	for _, zone := range []string{zone1, zone2, zone3, zone4} {
		err = deleteAllDnsRecords(email, apiKey, zone)
		handleErrorFatal(err)
	}
}

func handleErrorFatal(err error) {
	if err != nil {
		log.Fatalln(err)
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

func deleteAllTunnels(email, apiKey, accountID string) error {
	var err error

	client := cloudflare.NewClient(
		option.WithAPIEmail(email),
		option.WithAPIKey(apiKey),
	)

	page, err := client.ZeroTrust.Tunnels.List(context.TODO(), zero_trust.TunnelListParams{
		AccountID: cloudflare.F(accountID),
		IsDeleted: cloudflare.F(false), // Only list active tunnels
	})
	if err != nil {
		return fmt.Errorf("failed to list tunnels: %w", err)
	}

	for _, tunnel := range page.Result {
		fmt.Println("Deleting tunnel:", tunnel.Name)
		_, err = client.ZeroTrust.Tunnels.Delete(
			context.TODO(),
			tunnel.ID,
			zero_trust.TunnelDeleteParams{
				AccountID: cloudflare.F(accountID),
			},
		)
		if err != nil {
			return fmt.Errorf("failed to delete tunnel %s: %w", tunnel.Name, err)
		}
	}

	return nil
}

func deleteAllZeroTrustApplications(email, apiKey, accountID string) error {
	var err error

	client := cloudflare.NewClient(
		option.WithAPIEmail(email),
		option.WithAPIKey(apiKey),
	)

	page, err := client.ZeroTrust.Access.Applications.List(context.TODO(), zero_trust.AccessApplicationListParams{
		AccountID: cloudflare.F(accountID),
	})
	if err != nil {
		return fmt.Errorf("failed to list zero trust applications: %w", err)
	}

	for _, application := range page.Result {
		fmt.Println("Deleting zero trust application:", application.Name)
		_, err = client.ZeroTrust.Access.Applications.Delete(
			context.TODO(),
			application.ID,
			zero_trust.AccessApplicationDeleteParams{
				AccountID: cloudflare.F(accountID),
			},
		)
		if err != nil {
			return fmt.Errorf("failed to delete application %s: %w", application.Name, err)
		}
	}

	return nil
}

func deleteAllTokens(email, apiKey string) error {
	var err error

	client := cloudflare.NewClient(
		option.WithAPIEmail(email),
		option.WithAPIKey(apiKey),
	)

	page, err := client.User.Tokens.List(context.TODO(), user.TokenListParams{})
	if err != nil {
		return fmt.Errorf("failed to list tokens: %w", err)
	}

	for _, token := range page.Result {
		fmt.Println("Deleting token:", token.Name)
		_, err = client.User.Tokens.Delete(
			context.TODO(),
			token.ID,
		)
		if err != nil {
			return fmt.Errorf("failed to delete token %s: %w", token.Name, err)
		}
	}

	return nil
}
