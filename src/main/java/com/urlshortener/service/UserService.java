package com.urlshortener.service;

import com.urlshortener.dto.RegisterForm;
import com.urlshortener.model.User;
import com.urlshortener.repository.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.userdetails.*;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

/**
 * UserService — demonstrates:
 *  - Spring Dependency Injection (@Service + @Autowired constructor injection)
 *  - Implements UserDetailsService for Spring Security session handling
 *  - CRUD: Create (register), Read (findByUsername)
 */
@Service
public class UserService implements UserDetailsService {

    // Spring DI: injected by Spring through constructor injection
    private final UserRepository userRepository;
    private final PasswordEncoder passwordEncoder;

    @Autowired
    public UserService(UserRepository userRepository, PasswordEncoder passwordEncoder) {
        this.userRepository = userRepository;
        this.passwordEncoder = passwordEncoder;
    }

    /**
     * Spring Security calls this during login to load the user.
     * The returned UserDetails is stored in the HTTP session — session tracking.
     */
    @Override
    public UserDetails loadUserByUsername(String username) throws UsernameNotFoundException {
        User user = userRepository.findByUsername(username)
            .orElseThrow(() -> new UsernameNotFoundException(
                "No user found with username: " + username));

        return org.springframework.security.core.userdetails.User.builder()
            .username(user.getUsername())
            .password(user.getPassword())
            .roles(user.getRole().replace("ROLE_", ""))
            .disabled(!user.isEnabled())
            .build();
    }

    /**
     * Registers a new user — demonstrates server-side validation beyond annotations.
     */
    @Transactional
    public User register(RegisterForm form) {
        if (userRepository.existsByUsername(form.getUsername())) {
            throw new IllegalArgumentException("Username already taken: " + form.getUsername());
        }
        if (userRepository.existsByEmail(form.getEmail())) {
            throw new IllegalArgumentException("Email already registered: " + form.getEmail());
        }
        if (!form.getPassword().equals(form.getConfirmPassword())) {
            throw new IllegalArgumentException("Passwords do not match");
        }

        User user = new User();
        user.setFullName(form.getFullName());
        user.setUsername(form.getUsername());
        user.setEmail(form.getEmail());
        user.setPassword(passwordEncoder.encode(form.getPassword()));  // BCrypt hashing
        user.setRole("ROLE_USER");
        user.setEnabled(true);

        return userRepository.save(user);
    }

    @Transactional(readOnly = true)
    public User findByUsername(String username) {
        return userRepository.findByUsername(username)
            .orElseThrow(() -> new UsernameNotFoundException("User not found: " + username));
    }

    @Transactional(readOnly = true)
    public boolean usernameExists(String username) {
        return userRepository.existsByUsername(username);
    }

    @Transactional(readOnly = true)
    public boolean emailExists(String email) {
        return userRepository.existsByEmail(email);
    }
}
