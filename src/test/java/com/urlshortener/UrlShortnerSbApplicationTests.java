package com.urlshortener;

import org.junit.jupiter.api.Test;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.test.context.ActiveProfiles;

/**
 * Smoke test: verifies the Spring application context loads correctly.
 * Uses the "test" profile (H2 in-memory DB) so no external PostgreSQL is needed.
 */
@SpringBootTest
@ActiveProfiles("test")
class UrlShortnerSbApplicationTests {

    @Test
    void contextLoads() {
        // Passes if the Spring context starts without errors
    }

}
