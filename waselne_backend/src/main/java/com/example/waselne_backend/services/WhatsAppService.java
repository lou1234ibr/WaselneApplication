package com.example.waselne_backend.services;

import com.example.waselne_backend.dto.WhatsAppRequest;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;
import org.springframework.http.*;

@Service
public class WhatsAppService {

    public boolean sendMessage(WhatsAppRequest request) {
        try {
            RestTemplate restTemplate = new RestTemplate();

            String apiUrl = "https://graph.facebook.com/v19.0/YOUR_PHONE_NUMBER_ID/messages";
            String accessToken = "YOUR_ACCESS_TOKEN";

            HttpHeaders headers = new HttpHeaders();
            headers.setBearerAuth(accessToken);
            headers.setContentType(MediaType.APPLICATION_JSON);

            String body = String.format(
                    """
                    {
                        "messaging_product": "whatsapp",
                        "to": "%s",
                        "type": "text",
                        "text": {
                            "body": "Hi %s! Your bus seat(s) %s on route %s departing at %s on %s has been reserved successfully. Thank you!"
                        }
                    }
                    """,
                    request.getPhone(), request.getName(), request.getSeatNumbers(),
                    request.getRoute(), request.getDepartureTime(), request.getDepartureDate()
            );

            HttpEntity<String> httpEntity = new HttpEntity<>(body, headers);

            ResponseEntity<String> response = restTemplate.postForEntity(apiUrl, httpEntity, String.class);
            return response.getStatusCode() == HttpStatus.OK || response.getStatusCode() == HttpStatus.CREATED;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
}
