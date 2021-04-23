package com.isakmohammed.account.repository;

import org.springframework.data.jpa.repository.JpaRepository;

import com.isakmohammed.account.model.Role;

public interface RoleRepository extends JpaRepository<Role, Long>{
}
