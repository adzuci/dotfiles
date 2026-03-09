# GitHub Jira Integration Chrome Extension - Safety Assessment

**Extension ID:** `faenbbkpfnklhncjianlfllkfekgghih`  
**Chrome Web Store:** https://chromewebstore.google.com/detail/github-jira-integration/faenbbkpfnklhncjianlfllkfekgghih  
**Source Code:** https://github.com/RobQuistNL/chrome-github-jira  
**Assessment Date:** March 9, 2025

---

## Executive Summary

**Verdict: SAFE for typical use** ✓

The GitHub Jira Integration extension appears to be a legitimate, low-risk productivity tool. The source code is open-source (Apache-2.0), has no evidence of malicious behavior, and follows good security practices. No data is sent to third-party servers.

---

## Detailed Analysis

### 1. Data Flow & Privacy

| Finding | Status |
|---------|--------|
| Third-party data exfiltration | **None** – Extension only communicates with GitHub (read-only DOM) and your configured Jira instance |
| Analytics/tracking | **None** – No tracking code found |
| Credential storage | **Local only** – Uses Chrome's `storage.sync` for config; Jira auth uses browser cookies (session-based) |

**Privacy Statement (from extension):** *"This program does not send any data to any third party server."* ✓ Verified in code.

### 2. Permissions Analysis

| Permission | Purpose | Risk Level |
|------------|---------|------------|
| `activeTab` | Access current tab (GitHub) | Low |
| `storage` | Store Jira URL, template preferences | Low |
| `*://*.atlassian.net/*` | Fetch Jira ticket data | Required |
| `*://*.jira.com/*` | Fetch Jira ticket data | Required |
| `*://*/*` (optional) | Custom/self-hosted Jira URLs | Required for enterprise |

All permissions are justified by the extension's stated functionality.

### 3. Code Quality & Security

- **Manifest V3:** Uses modern Chrome extension standards (upgraded in v1.3.0)
- **No obfuscation:** Code is readable and auditable
- **No `eval()` or `Function()`:** No dynamic code execution
- **API calls:** Uses `fetch()` only to user-configured Jira URLs
- **Open source:** Full source available on GitHub for community review

### 4. Potential Concerns (Low Risk)

| Concern | Details | Mitigation |
|---------|---------|------------|
| **XSS via innerHTML** | Commit messages and Jira data are inserted via `innerHTML` in some places | GitHub sanitizes commit message display; Jira data comes from your own instance. Risk is low. |
| **Jira URL configuration** | User must configure their Jira URL; misconfiguration could send requests to wrong server | User-controlled; no automatic discovery of credentials. |
| **Optional `*://*/*` permission** | Broad permission for custom Jira URLs | Only requested when user adds a custom Jira URL; standard practice for self-hosted instances. |

### 5. Reputation & Maintenance

- **Publisher:** DukeSoft (Rob Quist)
- **Users:** ~700–800 (Chrome Web Store)
- **Rating:** 4.4/5
- **Last update:** v1.3.2 (active maintenance)
- **License:** Apache-2.0

---

## Recommendations

1. **Before installing:** Configure your Jira URL in the extension options. Use your company's official Jira domain (e.g., `yourcompany.atlassian.net`).
2. **Enterprise users:** If using self-hosted Jira, verify the URL before granting optional host permissions.
3. **Monitor updates:** As with any extension, review changelogs when updates are released.

---

## Conclusion

The GitHub Jira Integration extension is **safe to use** for its intended purpose. It displays linked Jira ticket information in GitHub pull requests, fetches data only from your configured Jira instance, and does not collect or transmit data to third parties. The open-source nature and minimal permission set support a positive safety assessment.
