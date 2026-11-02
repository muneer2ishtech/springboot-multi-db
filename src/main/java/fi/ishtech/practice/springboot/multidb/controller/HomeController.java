package fi.ishtech.practice.springboot.multidb.controller;

import java.sql.DatabaseMetaData;
import java.sql.SQLException;
import java.util.LinkedHashMap;
import java.util.Map;

import javax.sql.DataSource;

import org.springframework.beans.factory.ObjectProvider;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.boot.SpringBootVersion;
import org.springframework.boot.info.BuildProperties;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

import lombok.extern.slf4j.Slf4j;

/**
 * Controller for info URLs
 *
 * @author Muneer Ahmed Syed
 */
@RestController
@Slf4j
public class HomeController {

	@Value("${spring.application.name}")
	private String appName;

	@Value("${spring.profiles.active:#{null}}")
	private String activeProfile;

	@Value("${spring.datasource.name:}")
	private String ds;

	@Autowired
	private DataSource dataSource;

	@Autowired
	private ObjectProvider<BuildProperties> buildProperties;

	@GetMapping(path = "/")
	public String index() {
		log.debug("In web root");
		return "Welcome to " + appName;
	}

	@GetMapping("/about")
	public ResponseEntity<Map<String, String>> about() {
		log.trace("Getting application details");

		Map<String, String> results = new LinkedHashMap<String, String>();

		results.put("applicationName", appName);
		results.put("activeProfile", activeProfile);

		results.put("applicationVersion", appVersion());
		results.put("springBootVersion", SpringBootVersion.getVersion());

		results.put("datasource", ds);

		results.putAll(dbMetaData());

		log.debug("About={}", results);

		return ResponseEntity.ok(results);
	}

	private String appVersion() {
		log.trace("Getting application version");

		// BuildProperties is absent when META-INF/build-info.properties isn't generated (e.g. run from an IDE without Maven)
		BuildProperties props = buildProperties.getIfAvailable();

		return props == null ? null : props.getVersion();
	}

	private Map<String, String> dbMetaData() {
		log.trace("Getting DatabaseMetaData");

		Map<String, String> info = new LinkedHashMap<String, String>();

		try {
			DatabaseMetaData metaData = dataSource.getConnection().getMetaData();
			info.put("dbProductName", metaData.getDatabaseProductName());
			info.put("dbProductVersion", metaData.getDatabaseProductVersion());
		} catch (SQLException e) {
			log.error("Error in accessing DatabaseMetaData", e);
			throw new RuntimeException(e);
		}

		return info;
	}

}